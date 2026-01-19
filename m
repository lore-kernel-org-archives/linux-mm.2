Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A12CCCF2EA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45716B0195; Mon, 19 Jan 2026 06:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2EE6B0196; Mon, 19 Jan 2026 06:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3176B0197; Mon, 19 Jan 2026 06:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB0066B0195
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:36:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 596BDBADE0
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:36:28 +0000 (UTC)
X-FDA: 84348510456.29.5752ED3
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 68C0E1C0002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:36:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=km0jpA8W;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768822586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFpnCWhGNwWJuXsGKzqihX1fGRnDgxZyJ8bknQ6BEd4=;
	b=2v76+gDBe67PDMMUiOSiEfLbtXb221cHC76elr10m52R7nty6MP+18GAL3rElp4u68+aCi
	RdCyIbmHJ7R0m7pwLFROIkmZYw6Vyh/W5mHNoOXTzHNUBXtlbsm8uhlmOWSBkaGKZc8XDs
	FlBMzYWnhcjKGscfmyNmtgsaJWd3E98=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=km0jpA8W;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768822586; a=rsa-sha256;
	cv=none;
	b=3KPX3UrGAyDrBVmxCLa5+zvSNRadOoB6F6fbcnlSZY1qa5EMKWFzoVaIiNXP9HFMe7rncj
	eG3WdEJnHnrE/lwFS0Ip4HP/V8H3/njjRKMdAe7Y4H0cHdxvET2y6QY4qPdpto8f0oGesG
	Qi/0FaLpbNuphwB4kXjZ1iM9ijGXZwo=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-59b7882e605so5562695e87.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768822584; x=1769427384; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oFpnCWhGNwWJuXsGKzqihX1fGRnDgxZyJ8bknQ6BEd4=;
        b=km0jpA8WrSpPW+FTR2ZdNayRbLoA78oiXaQDX08+wj/grp/6SGQweNOd5BC5RGVKyO
         T0V3jx3102nY9UR/CIZam3FRavbCDY005SFhPTPpp3PpjXAc0D4VK1EAqz7lkohgdqjJ
         +Kj2TYQmuJx/AWIRxrGXAkdDo3axwg/hFWtlwSF2ICUdkexZmjnOEexJvHK+KdQnfU5Z
         drB1peubkkFbPQ4SbMoxchcucdWS20jM9wG9BnTV7HrbI96+pus3tDc0LKaW7Ibp1YOq
         gjUpOj2Lyx/hIeXc4zsqjVEz/RtQ0hC2Wbsl3IiqYmcgrZ0zlZkHcwNLIosQfBxO/ePP
         62Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768822584; x=1769427384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oFpnCWhGNwWJuXsGKzqihX1fGRnDgxZyJ8bknQ6BEd4=;
        b=RMadkYAgboQkaAmu5jIepuGoNtjwxfcR4HEm++88Uhez7T7jZXpYp08opPbxzLmQtr
         HARAySHVC2dOm/pOaIdR88/Rwk1eCQHaPzvOLhunvJoXk2bIuD9fMRd+te7xQtyhtoBX
         gJrxRXhwzNJUWlKbUYQhxqM92OuX03dPWCExznLlRKVaqGcJNL08/zXu2ySE/kjqEXIk
         /kJU7d0qZXBr3+slqfH2mIb/pJX+dIQC+lT7cOHJjtv3i4tW8WFb65jAo+akeMHeCFaF
         y69PqBum5LzjJoUt56TefUe1MMPDOrq8hwEXBmknvT/bPvQ+RvjWcbJpJc9l1UYVgOnL
         IqxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpnKifyTUQTJ4KBMtUvxmvRT/cEaXg/jAynp7xDwknVZbPlI6EABWc74wcq7dfjCBrZXE2jw1sLA==@kvack.org
X-Gm-Message-State: AOJu0Yy6MMR7IuCIbywj8uMm/Q6pl5I2OX74xhLohVrg2TZpF+7+k6J4
	dzJpH3ZOTirefzmPXGHeX7hnn0rNfSAUBhHtm/MMoaFSRNexNxEXVsUp
X-Gm-Gg: AY/fxX5mKW1eXfbHZjvXfLgNy2unbiDrc+gheoZBFEW+ALKCP7AAwzCjai9s/GTIVFI
	74aCp6xF5oV14/3zcUwKX8VRvRilopdcfTOkxUwk9H4Kvfz5BFzE9qO96h0mRbnuMBBQzOk6xnQ
	Br/O9HByI0pgPMlvqR4KDsoOTbV0CL/faOWIN8g+8fSXkBKX1X6hGjFdGfDhfk2QmakgqfoBbSO
	uR0eKtMxojvKPXWQNmKO87SdUwaDX/NfxDhv0y5FpvikaGAjK7jNKRBy2en++wIScCEwGHxplTn
	I7OocjxfmvzqeiJvHsyk+6n2ysxFp70nZAasrej4PMcBX2o4ZMV/WitHLVj9L0pp2l8B/yqGSIf
	3fOSjs39GA54S6kWszQ3ZOF98lO7lbOHi9LVeNeQTkm3c9snJ5nyD
X-Received: by 2002:a05:6512:3b07:b0:59b:b3e3:c7fb with SMTP id 2adb3069b0e04-59bb3e3c825mr3094854e87.9.1768822584194;
        Mon, 19 Jan 2026 03:36:24 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf397ae4sm3285108e87.59.2026.01.19.03.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 03:36:23 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 19 Jan 2026 12:36:21 +0100
To: Audra Mitchell <audra@redhat.com>
Cc: Audra Mitchell <audra@redhat.com>, shuah@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@suse.com, surenb@google.com,
	rppt@kernel.org, vbabka@suse.cz, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, david@kernel.org, urezki@gmail.com,
	raquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/test_vmalloc.c: Minor fixes to test_vmalloc.c
Message-ID: <aW4XNSD6jzHUZlWn@milan>
References: <20251201181848.1216197-1-audra@redhat.com>
 <20260118173036.fd0784f59848303024065b9b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118173036.fd0784f59848303024065b9b@linux-foundation.org>
X-Stat-Signature: ex4trkhppg1asudky4x48p8nftwb9eop
X-Rspam-User: 
X-Rspamd-Queue-Id: 68C0E1C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768822586-550682
X-HE-Meta: U2FsdGVkX19wjbmvZP4zFPXtzG+MrlNn//5DkcCDeiH+lVefqoTK8vgch/nNq3mgs6jj4kS0bPUH4GcN6uFMdBM5xAY0kK8EaS79ZKDuxNIUeCRy6CCMyMQj1XLCyshzGu+MyMoqLKijeok/JSAV9Y1CEDnqfC9mfTbkOPXP5jPC33hIq1SOxE0y/O2jml2twDB9ycFTOQ7TwYO5Byvov56nSnUveUXjJXwBjyD7i3E3kT+tkBEKdxoIV3PYahaSaCQxPgcVJgJubNXMWRqFBmR2PO0rWxyq571Ab9/8XHPK5WvMWdkHfKnBk0zjwvSnDAVhnvnRd69Um51jvHBJwoBCQ88f6X9tFx2VP35yecYqfvUyEnLvO6ta3m2S3P/LQ9ZvkcJzApE7VDkZMMXI462ectXDslPbKwhndFi9Q9y/BV4cKq0iPV60OMmQZ8oFw9DBWYH4dHc82iybpEU9KvBm//TsRydiph+l+PzArsootMSn4oJqdUbk+Zt9dqM6XzElzuX86fb/cCcSM+1FszvDMfct3oEWlBdulfz3fEMR45NnsmXcktQycPdocR9IejsnDtnjAsG6uaclr77rSRLTs20PbxA/4UzSBv+pzifLBnNpZNyH4KN8P14MkJ4sCvCpqKKf8tWqTEpUVDdm+nbG9lugWJZ5MssedzfaZIsyne7peOy2QvIhOEE/xBW2zII2fGsehglAzN0YA7n8+2WFlCyHlwkerOH9s68n3/esQWnAG/vcnnLMFiTYU1LulLoHYEueS+KITTskO1nA8N9AA1pE2FCdmfLznNgZ+FhavsMb3om3atMlnKOxVM4eDmJile3vXX+VtzZ/6RvPghq0vHZB27UcDBTJs8NcS1AYWEITfQF+yVqN06XJ6EadrqviONMXyh73coIwIcxqZQhhOF//bPndhuRj3ZdusKaUHP2GZq+1lqMBT1FXmwV8Y/GVmJlRx1sIjSZtoGF
 Q2v/rmrx
 aNQabkuKuoJ9DrP2SL5O2pdZs7NCnEuT4r30LEXXWgSKLzdloh9gkYzUlRj0z6a18e9cUf+8/Gh7U3S8D3xXXBrHpkn4jFnAkqUfXfhChjRsxdZYrt4a7msHBF4PQqqnnOTSbTmYde+fwaKdhVSqYqPDr3iZ0bHmIxSPDUsit5ZdbdXLpH83D0V9KDwIMSCc8Njng9zXXKvm++6hER0vPJqiBr9Ovc4Xl8sBcGnAB5K82PcrJOeoNEK60I5+AOsN6clwT9j5t17o2s1HWo3O7LPonroRMMxI44LTBtjZK9CYRDy6fc4BsO0wlcALI6CWaJid3ottTJ+mof1WEslsCJvHphj/pxJ1jQAkPagj6wYIuqeVV8a0V2vjEX64KUShR05yOudXnKTiJRT1RXV+V9WKzSju/DRNTsdUHAh2N/pP3KYofAFeoAgc8jU7905Cm/Po7gHFxo8RYYf5gtiI+x4q/naTyBbjUsTiKvXLsHzitGNwt3eRjLhtcuhZTpM49pH/QhzSpPZMSq0Tb+rGzd9M8UTepvOotK56bqbiiCdY5J+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 05:30:36PM -0800, Andrew Morton wrote:
> On Mon,  1 Dec 2025 13:18:48 -0500 Audra Mitchell <audra@redhat.com> wrote:
> 
> > If PAGE_SIZE is larger than 4k and if you have a system with a
> > large number of CPUs, this test can require a very large amount
> > of memory leading to oom-killer firing. Given the type of allocation,
> > the kernel won't have anything to kill, causing the system to
> > stall. Add a parameter to the test_vmalloc driver to represent the
> > number of times a percpu object will be allocated. Calculate this
> > in test_vmalloc.sh to be 90% of available memory or the current
> > default of 35000, whichever is smaller.
> > 
> > ...
> >
> > --- a/lib/test_vmalloc.c
> > +++ b/lib/test_vmalloc.c
> > @@ -57,6 +57,9 @@ __param(int, run_test_mask, 7,
> >  		/* Add a new test case description here. */
> >  );
> >  
> > +__param(int, nr_pcpu_objects, 35000,
> > +	"Number of pcpu objects to allocate for pcpu_alloc_test");
> > +
> >  /*
> >   * This is for synchronization of setup phase.
> >   */
> > @@ -292,24 +295,24 @@ pcpu_alloc_test(void)
> >  	size_t size, align;
> >  	int i;
> >  
> > -	pcpu = vmalloc(sizeof(void __percpu *) * 35000);
> > +	pcpu = vmalloc(sizeof(void __percpu *) * nr_pcpu_objects);
> 
> Could have used vmalloc_array() here.  Otherwise lgtm, thanks.
> 
We can also reduce the default number from 35 000 to smaller one
since this patch makes it possible to control it via parameter.

--
Uladzislau Rezki

