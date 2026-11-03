Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9784D606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cwcuZ74L
Received: by kanga.kvack.org (Postfix)
	id C5BD76B00EF; Tue,  3 Nov 2026 06:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05BE6B05B1; Tue,  3 Nov 2026 06:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4A36B05B5; Tue,  3 Nov 2026 06:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88F0A6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:56:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 238D8A7DAF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:56:10 +0000 (UTC)
X-FDA: 85393654500.11.5A44CE5
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F0BCA0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:56:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cwcuZ74L;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONK88Mc3FVMhpnTXlcgn9JF9XGNsz0fFBW8JVFGM8tQ=;
	b=MWSx0jdzFhySq3Jgb3Z1j7tJkFd9UzZBM6KlpR5qMd0qVWMyEvOOsGNucpSf1cqB2FJzlv
	STM1kXuofOJpwe39pLViNtLlMGTSnca3R2Lqxt+UnTc2eXuceU7wROLIKeQ/Fp9M05oFyY
	srmkfwq5zaV4E8johf4WGG4B+BLD79s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706968;
	b=OS0nHvew6RROfh6ri5N0JVJ75U2hXJNiW1nsY47p95OBs6Q+OdlQVF9hVt/wIfJVQwkNUN
	FUE7RGF2joAN5h/L3Su41+60Ok09lmEF4tIRGsstvDyZsOuPjjs4a3tNPBwrGYh7As9pDm
	X565+ddKEI1Vud+INrNOCl11j+SpPb4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cwcuZ74L;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2e613f813b0so13836365ad.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793706967; x=1794311767; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ONK88Mc3FVMhpnTXlcgn9JF9XGNsz0fFBW8JVFGM8tQ=;
        b=cwcuZ74LrfqGqBtO7ey0VbHpatbUvGY/lrMTtZP4/AacIuQ10X20tGt1UrLptgTimo
         K9LE/sZ/+4PqGnC8QzJARRf0LSTEuXSwgOAb9IAw2+8SmGqXy+8z/SVxTBfL2/bLYlCo
         LolUolUjPEoloFZXFXUhYWZg8T71K1Lsm5KUhZvELLBmzcTK9MUf1pb9OJIhTT6T+xdz
         tT51Zvi4XZAS6rnrIR2IcVSZrAtCNVc8qefx1gOfShXiHjtCK7vYKUOTRqRqEiPyMOK8
         uKfLCYoc4nhmCHSP8ZtkSo71cmqYCp9G8OHRf/tDqA/MrOAfvJqz9CPExU/iCSasz60H
         nLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793706967; x=1794311767;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ONK88Mc3FVMhpnTXlcgn9JF9XGNsz0fFBW8JVFGM8tQ=;
        b=nPkozNLiAGvWbn84O8g+6zMMhbzzIfXH3K6BWEl3/tmPjsIpNMTjND2oQ8b7QHlfFB
         1BObWS7g9skFhePM8u67HmqIqw/zgdZ+NGUhPHToLL8soNSwCjwmVJujQrHxdnjnBTxT
         cOkR/QB90LdCtKOtl7XUaRUeIfOV55/to7AM14uQGN5s7qJMZEIscEjjrjv5d01g9HUp
         VPQOsSX4KqKxGErO0JyYNcNsbUwyq1j3WPHqk5RgDU290KmKsYnTDOopynLQZS2qafAe
         KLdJW9TTgst4SOiGiqKplCjQqEUrRDlzelZYAXvhWDVN+XnKHy26Vw76qZM1Moe7S2Qu
         1sYQ==
X-Forwarded-Encrypted: i=1; AKwUvBzEyMUlKJNxBvZY2iQCI0chn8pGHodkNHS5M0Ca+bWgVtiEKOAVoRHTfNjh3bxxJK54txAaacHBjQ==@kvack.org
X-Gm-Message-State: APuU4Z9uvxRZO9PTmXvJDWI9xu1/HCSktCK3tc36RYftdj8m0krsrGOQ
	JctAxkLCMik/dYl3CcjDzVWFBs0BJzU5JnT2GcaRy9gUmhnV3NXtuWJt
X-Gm-Gg: AYBFou0kR1pMtx1h5R6MpGgM35tntj3u4+d3OtU/441zbI+5oWPXZxv/6PmSyX0qOU+
	ArI6L8WOGLbolBfrjdbzkIGkkLD4VpV/7bVa7YLZ1E4b2d9qB1F9b1IGo3witi+8mzgcOzBZWdk
	O7g1Sifufrhwb5JYj/l5s+qaquSspKgvEbyBGnIcDzYWlOJSLVAo71oGcjyNDdwOXhNepXnRMzh
	VMwyFv+pH3r2y9rbQziMRMDs8dBc/+y9nl5naRRX+ot2655tDMl529iPjNiajR068QYpw/QGPqI
	Bgp1v6QT3LDmIvgH7zewOgBGvqwZSGRB6NK62hhsgQl3BYmOsHbYoa9r7pFtLEmhiIbxJZn8UBD
	mLYR2klzmleDT8dodQo0fnutd2NWQ4M93mZoUm4WLqduYmfz0OXhK+Ot5BnylvtNJ9SxeKoPa9f
	Fh6l+EbNh9exM35yZtYWZdRurZuc5Bh6HERJpPtRR/FhRJegGOyBNhTEpk7dd3c/T4BFo47h+p5
	M9q8tovf0hZVQZMV21K9ETZpnCuH5sGcSNqhyj8Rzs/mtrWftBGRT9EAeUgUamhbPrAar189pP6
	GWBFaBY7C5/0JUIsF6x8rwtthFkI02yFzcWWATHmO3diDkH6xlm+RufI9V18ekO0cyNFldhKXWb
	ccBhK0DJf9Bz0JzEDiJ6zPbqwV54=
X-Received: by 2002:a17:90b:1b0d:b0:3ac:36c7:c144 with SMTP id 98e67ed59e1d1-3ae89776936mr6987759a91.28.1793706966861;
        Tue, 03 Nov 2026 03:56:06 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3aebc89475asm5134252a91.0.2026.11.03.03.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:56:06 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/damon/core: reject empty access pattern intervals
 on scheme commit
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 03 Nov 2026 22:44:03 +1100
Message-Id: <179370624368.195197.14262032219867976650.b4-reply@b4>
To: "Xiaolei Wang (Kaihong)" <xiaoleiwangxiaolei@gmail.com>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, david@kernel.org, 
 error27@gmail.com, "Liam R. Howlett" <liam@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 sashiko-bot@kernel.org, sashiko-reviews@lists.linux.dev, sj@kernel.org, 
 stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261103105418.362459-1-xiaoleiwangxiaolei@gmail.com>
References: <20261103105418.362459-1-xiaoleiwangxiaolei@gmail.com>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F0BCA0006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: re7keit36wg7u65xa9xf44rkk61an93c
X-Rspam-User: 
X-HE-Tag: 1793706968-898453
X-HE-Meta: U2FsdGVkX19/+EDHrwDTHPF6niLP2Sdf3O0ygTRR2fNDp8udIy9KGrGVmVcw0oJVztdEtkYVh5H9DY+lbCBUZinDj2Ajm0o2BB0kX9eK4O7qdvB2m3pqDeCL4yIYZFDHGkxwAp3YpKqOT6eNdo6KVKDpOksnp0GeTQmVrXgVd4TTx6gJQpSIRTBBeHvOhakwNZCQxV9CXERVRgiwn3p4UsOt6LgZb+i9Yqr/BabRA170XZnWHycraxZS2Ak6gl8c+UOwZHa99FtYZPsuwZsNI6Rxjl7f22kTv2dgQEtSdUCBtYNpHwhtRS4/za+zP9AHszpMeIuZj9EPGuJFJqpqJPREC32HuBpS04nYgmZP+oDqBMadyf3gNA+6xW8AzyeBvdrl+tJcxh3NaCJx4W0hXqRqzamF/Ez74N8i6xL/m3bsrVEL+v48DLlJhFtZL04/JJfpeyCJhZnh5QwIYeno3uyGHh+vNF+sIq+/e7lCfEODWzo2BEFyBb78TNxBjYtrJmNPqh409ApDZysp23SoyoYW25WKftI/+f34Xi3MXRJdRVxb8SuDoL9z2Gs1jK3ha7nxU4y/IuM1TiilBNbasGUA2IQYOXtZcFiWNUE0KyQDnHQ5n8gDvrdBjj3UCtzNDBTDUBPvvthfd5Xum/kbDjXc5kb+HOxuiS/DbUEyL/WPhND/2wJlo6nhiADM9lfxwbLAbG+29TXjsK+Bl0vd9ZItIrBn7w7dlrL8xMq/yQSowfG86UgAL43/P+NGPjlHrPpjwqlL2WyTr4Y70XYp+5fgS5OJUVTKDB3SahIzmSCoF57GA9aiF/1/LFT6Pu/lA8ooX74nMwSkbXUb4fuMztTpXITV3ei3Nuscx0H/4INMuzOO0d6cIpqntUOYjdmHVy2HAbShXbu0ZRaWDbnRAlSppo5G3gNvNgcUnAGtdhSXYgqn18QlD2xq2Cxz7mCrAsTwjD+y2NI/PyUUn9F
 C6uweHJe
 oNdWn6ymuXwFog8yHnbgp4upWYCWekhMSnWv2sQW7VIFEHG2nPe315brNoem26rqn01uClo/KqP2i5QNnm4feXP4mmO0wA+BLRTNUv6IpdO1+HE+NcGBfpv/phO/JvzE1BRvJcWy8p+xQ029YZ2inWS7CnePjgn3/r2e6nOqE5AcFmi+d7mUDTBrQVFDexa61OqEn0gLMmTxU+TRwe+alZLzu7YzxTI3NiB7Tn2P9C5ybhle3NfGyo+g2Xw/bJ+fj2rrIVLcU2AtjaOjB15jr29dSaMCNDS1ZcKvIEBwFPmksraU+9Nozu9gGrL1FAlC6Wz9t4oied8G72HeMBfQP//+VnklyXAHJUXW3FabKf7KRKKo+s6ji17B6zURJs44ZLo7IZqc3ESdNV0TKcxVeZRqMyHl0nGSBkuNNsyq2Q5ABNnEVHHeNtDcekCGNX56mlJMX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Xiaolei,

On Tue, 03 Nov 2026 18:54:18 +0800 Xiaolei Wang (Kaihong) wrote:

> At runtime __damos_valid_target() evaluates "min <= x <= max" for each
> of the three pattern dimensions.  A reversed interval is an empty set,
> so every region fails the check and the scheme silently never matches
> anything: nr_tried stays zero forever while the kdamond keeps running
> normally.

My understanding is that DAMON just does what the user asked for here,
so this looks more like an input validation improvement than a bug fix.
Since previously accepted input would now fail with -EINVAL, maybe drop
the Fixes: and Cc: stable tags, and mention the behavior change in the
changelog?

> The same holds for the watermarks thresholds, which must be monotonic
> (low <= mid <= high).

Not for all cases, I think.  With mid > high (and low <= high), the
scheme still works; mid just has no effect.  The subject would also
need to mention watermarks.

> +	if (p->min_sz_region > p->max_sz_region ||
> +	    p->min_nr_accesses > p->max_nr_accesses ||
> +	    p->min_age_region > p->max_age_region)
> +		return -EINVAL;

As Sashiko pointed out, this would break the DAMON sysfs.py selftest,
which uses size=[4096, 2**10].  Maybe update it together, and also add
a kunit case and a note in the DAMON usage document?

Thanks,
Aveline Noir

