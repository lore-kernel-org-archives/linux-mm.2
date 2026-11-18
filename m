Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6F8606A338
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WK61djEt
Received: by kanga.kvack.org (Postfix)
	id DAEBD6B00EF; Wed, 18 Nov 2026 13:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60066B05B0; Wed, 18 Nov 2026 13:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E1B6B05B1; Wed, 18 Nov 2026 13:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 884BC6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:45:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E154D160865
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:45:13 +0000 (UTC)
X-FDA: 85449117306.02.617FC02
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1543640006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:45:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WK61djEt;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795027512;
	b=xHnqK+KvClFs9lQPnUIS0Stvkpvkjm4krdjSebMzgIA5GbScwODNf5Wi8Vydx5awe4Kw7F
	Vky4u1FExFR221iDgfiZLcdByhhnt8egvMgsDAif1gJiXkSOal2pOT5mXcdagfKA008t79
	OusDhL3oz8Hr3SrBhV1Uky4CF0Y8jVU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WK61djEt;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795027512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83fqcUvna35tEp0J39zKuHz3WIhVSAcOkZuTfVIzkBI=;
	b=Qzv44jkbJEDIeiwClxfd5Fzk56yqjJtjSauaZMXr936Z0TooE8P/NOhxhdoV/dMJ4qktcs
	fTKrhH7rouYCfzSZOofXQulNiE0LzJLZplT3ZsoP/FodAqSO9jz6bwrbHZdVEIH/XDIeRY
	V06lLltUeAMU64iyQWpgkZxB+WA9spE=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3b3bf3bef9aso1326961a91.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795027511; x=1795632311; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=83fqcUvna35tEp0J39zKuHz3WIhVSAcOkZuTfVIzkBI=;
        b=WK61djEtJ/5UpApwwhi1iQAWQmVfVg3/Qm/Syt3xWRYkxZTHe+zF4KN943qLkTx/p4
         svsfbzxGDk1lSQy3ckqoaOQWw7WBkRRDElQPGVir+WuZUqtlJUBOehyCvTsIbe+r9QC9
         bQgvoAQhhhAvA6uRWdHiQ5ZMKRBzQp76TMSuAtLE/4a0IATsqwwtUdRKGoNPRmiL8PUB
         4ILXME0ALRZ6zMaDMKXp5xyFaOzaYGcBLhZynI4yBHBJ6jD649R84vq1jZmYyFULHSnm
         JJeCibHjb/KrXhyHVwgk+AGVIDX0XqCb9rkaTyW8QPWsMdntqJPYB+NhSmy1tPTRzrbL
         wKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795027511; x=1795632311;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=83fqcUvna35tEp0J39zKuHz3WIhVSAcOkZuTfVIzkBI=;
        b=frlStTNan7amoUei0E6hc/n5LYmFKj+gYAnpt/2OhjjHyuJYIp6OrFXaWJUYEaY41L
         XQOIRXXJtumHjezNpJTpdNAm3x9Xm31re7koGxb2Gja8YEdB5CuBK/FufjLwUAjF9x+v
         9ISTKg8eV2bQjgw6Ax6mNHa3PveFq5te17VQL0HcDE1iw19D4d8q1AQIu/WY7bXbQ5mx
         aQ28WYozcVvtce0qxKjsfeh17JNaSBXgF4IHAJ5PYHwgIBm5tJYci5XqPSNHezZYGent
         PkAn1ooC7xUAG/Rc1GFIH3cO46IEZ0TpugPirc6wsEFu/22Og0rAcs0Lw2fgzLs6wUqu
         mBzg==
X-Forwarded-Encrypted: i=1; AL+hErGeGMBwF2kmXZllxZ+iw3hDaJ+m2usGLKAsadSQOs70I+BYUhbvwtgF3ngZ//8B+W5XhQ/czV/c4A==@kvack.org
X-Gm-Message-State: APuU4Z/2ztNzUTKlpa7eMdNYm2dJFuqTGukeruOx+jqplfyUSm2CZWsq
	6Qlpirf6c5b33tUsnyheCL/d7eoaMrHpsT1S6j8O7k/0hA+BxNO4x2vF
X-Gm-Gg: AZFdTZePM5zfRPdrOeVyRbHfOwMhqiCHDvbfFTapdc9jziSoiuirhHYcNhxoeJQtTXp
	u3dK7nA/UrFRdGdVdjNa19V2pc5BDFUP/qbOoXyppcqhnv8hX2CyUrYH8lKVyHlzhv8xRYIzdBL
	hrLM0HUx4vR5lcskrUciA28RZaUMM472fnE4pVkRmSYflHIGSKq6uuHeMuF/WMH4DlS/TpsCGGY
	xxNgTEPvu47YcwVxxBspHgnLfXWYSynm1D+SGI/sE6cGIdVRIY5tLn0Jun30d75OGe1dQ1oul8+
	dMwvM3OA45iY7YlSMoEh5Iobaxt+R214TMx+Rn360MQ6FQ0cuu4TBqfStq/mGeYGenJqirOIRGr
	r8j6iBx7LlNlXRtR+K2rOBTU4OeCWA351f3FF0g43iEebikHjTkRSMsAAiWhaSf32Xa+odLKOfJ
	QjAdinfEq56k6B8HQpZKuRNO96OqoNmuahxLr28F69vemWWhGIae0WwCvc8sWo5mSnF8diprqaV
	klqZ/akkI08IlfSt3LUqoY/LT0WKxa/VnRqFf8xsgoK/yB7/XKfwLTJ6uuz62HhfilMUwz/pv/+
	W1V/kVCdt6HcY1aIZSVjqVogpCo7BDPRYyOecgGQW9UEB0+EPxIp9u5/H8ayj5AAyfeq4JW74in
	nfE+hnXbNOu3ZxCw=
X-Received: by 2002:a17:90b:17ca:b0:3a8:c0cd:57fb with SMTP id 98e67ed59e1d1-3b3d07d4463mr3483749a91.42.1795027510501;
        Wed, 18 Nov 2026 10:45:10 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f6e1ae78sm422551a91.3.2026.11.18.10.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 10:45:09 -0800 (PST)
Date: Thu, 19 Nov 2026 02:45:05 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Tianyi Chen <hi@tychen.cc>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>, linux-mm@kvack.org, 
	Kairui Song <kasong@tencent.com>
Subject: Re: [RFC PATCH 0/1] mm/mglru: MADV_RANDOM page cache never ages and
 thrashes the oldest generation
Message-ID: <av3vMMhFbiaop7zA@KASONG-MC4>
References: <20261101160427.85701-1-maxmuzaf@gmail.com>
 <179502478384.194898.8139869410612997037.streamfolio@tychen.cc>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179502478384.194898.8139869410612997037.streamfolio@tychen.cc>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1543640006
X-Stat-Signature: 1dki9mawzexz8rf1zk5yo9ut77egskhf
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795027511-797132
X-HE-Meta: U2FsdGVkX19+NCQUb/gCPxPvQG4Pt/WZZZhIvZasfTJHStQmycLGmUZECvk6ItWADqZLc7xyHEPRPg6pRqXkYnQtQyN0uiA2LZRqxV4VSgNoGm4u0eH5erh3VnwoQ/dRQVtAMlWG9alKlrtA3ccUfsKNfcYjy5eRHzGMaO8y1pKT4ObRS4mFi54mjEWsI1rWRF9QM7QCOdGcD0nr6n35ctt3/DyOdD431mGbtDPadJcDDeY/l2SaPpk2HtzRfYd8AsW8V5xQzctLO6MKBvG3FzLKse1AnnhygVL4zwFUR4JUszbgde2IcO9ZH/EdQyrNo0xBWoOVU9A4rDkKxRvH/bKqv4NhhgM1Xv+O0DSLieRao5D23kQRw9aB6aqFLyxUsDwCEuiL5f3akBxuHXsDArbXHY6k6TfxdDLdi9YWsDrdjEr1HYzrV02QUv+mucTAnBv0j2NQxugOrxbUGuSOq/96WWhXy8unrD4Dl33CZAvvq41PmAcGw4wnXfhU0U9fHjpCN057mpZLwedfpEMPhEcj661OlvbbCRa36kO14oJBY5vjW11nrnpGO0bwX0tHSkp1GAg4wmQVG62/dIEd/yGaIzDyx/F1X+0kpdOcm/POnvOz6vfTLvgZMzmncObVQyIrZcEhwLwrMMHTLD1LHYrJd2eW/edMl+qLgVAGdMo5RIIuie5U6WT+D0dkxmH5YoiH/K4p/1J6t1Z7/M+yU43T12g+6VrGmS/eTjJrDAHktiTddFwvtdvztS39xV++mVv5Tl01L4VLSlx5pXhn02ROgU7yD63ujFISEfIhw+8UZeu+A0s1mQ1NY1/7qCgg1KQu1+V2RfBeqBDyapKSlh7fsBOQ2sKjA6kW8EOg0bfVg8hj9sFQ73MWURth2j5IxTT91Fxk7I+dg2agt1a8wdkLtgFwGpdvhiWs5L4RP4DAsJsEMLhKUuATtV54id9OJjgjPHloI3rrADqDZsz
 a6O+3ChQ
 F9tPhBn1cIIwIj+ZZ9nULpZ/OsMn00PfBN11/I3fNedccw/KMFOp7G6/0O33fasUnvhqdM25lwLx4GJ1LEcy23auo3iGGz1pWR8P/8BA1VhCofDHDghiaaRDeePq5TS5nT9ww0jkrTQoot0/JT4EyiXkbPc1k+dWEoG4c6B7ofOsqX4zMPln4TJWiHg5w/CYAmtriSZipUmsy93r+M5X3RxON9dcKW3Uhz7rCUaSLd+BuxW+BTsF20OKNFr2jdgHlo2cPJC0hQZdpLs6V10ZjwBmsz9r0+/tInApDkOa5M7bj/1bryPMkuIwmfPWX0k2PGkrNARdRPwufQkR1jZ5GN+IC4AEht2N+bBp/5A4tVYNWmstHmTlz5VuHUUtvOEtjCLOgfn4GFzIwHLlIN5XvwzvznfWq9vZdE3pip6iAsTJl0m4jv1uaKSMabUvyBotwziI0l8EO2f3bUjEx5jH8LlYNHS8//KqFShcrmiMPVZ9hyZw52BWKBSgS5owmKvf1okP21dlAmJ5BtW2FORaFGqh4VITSRDvRFr6tDRq8utcc1+hQtqwcHQUFm3ox4Um73XS1Jxx1AofGNh0JDAZEd2B0VRMx9KUZ8go5coDODi195YQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 05:59:43PM +0800, Tianyi Chen wrote:
> Hi Maxim,
> 
> I can still reproduce this on mm-unstable (1b697248a755). I used a
> scaled-down version of your fio script: a 120 MiB vector file, a 38 MiB
> scan file, and a 128 MiB memcg without swap in a KVM guest (scan at
> about 5 seconds, vector readers for 14 seconds).
> 
> It looks like vma_has_recency() is why the hot pages aren't promoted.

Hi Tianyi,

Yeah I also described that here:
https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com/

And in previous reply:
https://lore.kernel.org/linux-mm/CAMgjq7AEf_cJsLw4fxs7m5ntYPW9mjCOC_-w5j6ihk8F=xLRWA@mail.gmail.com/

> It returns false for VM_RAND_READ, so the MGLRU page-table walk and rmap
> skip the accessed bits for those mappings. Letting reclaim see those
> accesses again stops the thrashing. I don't think that's the right fix,
> though. In a single-pass random read test (warm a 64 MiB file, then read
> a 352 MiB file once in random order with MADV_RANDOM, in an 88 MiB memcg),
> that change evicted the whole hot set every time. I suspect that's the
> kind of case the check is meant to protect.
> 
> Your threshold stops the thrashing too, with more faults before things
> settle. Your patch no longer applies as-is, so I ported just the
> threshold to the current code. It never fired in the same single-pass
> test, and the hot set stayed resident. I'd fix this on the recovery
> side, along the lines of your patch or Kairui's refault-distance idea.
> 
> Major faults/s over the last four seconds or so, median of five runs:
> 
>   Configuration                          Major faults/s
>   Stock MGLRU                                    27,283
>   MGLRU, count mapped accesses again                  0
>   MGLRU, ported threshold                             0
>   MGLRU, no random advice                             0
>   Classic LRU, keep random advice                     0
> 
> I saw the same difference between MGLRU and classic LRU in a small
> synthetic OpenSearch 3.6 test. The median post-scan p99 was 109 ms
> with MGLRU and 5.5 ms with classic LRU.

Can you share the test step on that one? I'm working on the long
term goal of bring back refault distance:
https://lwn.net/Articles/945266

And the recent RFC:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/

And previous test with it:
https://lore.kernel.org/linux-mm/avd5bI-b9y1nKWw5@KASONG-MC4/

(Basically bring back refault distance will increase certain
DB performance by 5X, fio by >60%, and it should resolve the
workingset shift issue too).

MGLRU not performing well with certain over committed or workingset
shift is a known problem. Unfortunately bring back refault distance
is not that easy, the model doesn't simply fit and I'm trying to make
more space in the shadow for both distance and gen marker so it
won't break the planned readahead support.

The threshold of of refault distance re-activation is also very
tricky to tune for MGLRU, I hope we can do that after the FG series,
as demostrated by the RFC above (that RFC wasn't in the final shape
either though, that's why it's RFC).

I'll include your case to be covered and help fix these in the upstream
ASAP if you can help provide that :)

