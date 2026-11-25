Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B82A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P1caqa8E
Received: by kanga.kvack.org (Postfix)
	id 7998C6B0AEC; Wed, 25 Nov 2026 17:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A256B0AED; Wed, 25 Nov 2026 17:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6653B6B0AEE; Wed, 25 Nov 2026 17:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D80C6B0AEC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:10:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF70480142
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:10:30 +0000 (UTC)
X-FDA: 85475036220.02.5D0CBDB
Received: from mail-dl2-f7.google.com (mail-dl2-f7.google.com [74.125.229.135])
	by imf04.hostedemail.com (Postfix) with ESMTP id B827140016
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:10:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P1caqa8E;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795644628;
	b=n9u9rrjqStfkJD4MOiwM9ZJkn9fTb0vqad1avn27z5Uh8cfM8lSOkymQ2dfs5/NNbRDDxv
	OJT/vcTp2gUPwXP3vH29PIp5/QA2DoueFOeiGvdpqfsf00ZD1q9Btl2LZvCXca/doiz5cR
	BJAuXwyXtUvBnei5l1rJXtRQnYkkyq8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795644628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkBk2j5ivR/mh7ILFij97SNuJfGxESxh8j6/caNV86A=;
	b=Cr4r8oseTnhuqz+nbsFTv6+rffL0ezB69wxk/eEHh/pgSYmKDqa8dDHgorsZygrLlIQMk+
	SeROrEVFd1hNc2IVbMhr/+niQixtbMi434o3hDjR0hv8d6BlhSp2VzSJinkM4tm00H6dgQ
	iiMdl15Qz/rO6G47XfVCybLVLIZF5Jk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P1caqa8E;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
Received: by mail-dl2-f7.google.com with SMTP id a92af1059eb24-139b659a45eso694456c88.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:10:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795644627; cv=none;
        d=google.com; s=arc-20260327;
        b=Z0eGN+ngBsDiOcwhnablFiylB6nFt9thJIpZDTUS3hq47BfmVSBJGwxz9E3FStvW/U
         6PptxkO3r2quyjMSQRiF5lGenKKLtcyObCSzqog7pgc1FLGDAumVVPsjK4B6UMpNp9NG
         07/WZ+QT7ZbBQ8YG+T5rQUohjfsA8ZASJtBI43J0MwrzdGQIUMyjWEm55nNOD2s8bCxW
         oWmXhYUNJA95p5LJIejeqJGeo5pPY4cRNLHz3dmzzg16L57tHjqN3vNZucy3GLheBAMx
         14PIs7V+2/6uBowY9CFGLOoSSdQrqDj4HnhsR55fgNinqC9+yUT54FGU4qxD5QlarY8d
         ah+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CkBk2j5ivR/mh7ILFij97SNuJfGxESxh8j6/caNV86A=;
        fh=2P9aluS/k3M4x8DdsOtWcSKWzKMya7FwdBclavltDCM=;
        b=e5w/GCNpuqjUHQLDPDMhJGBIudBqAkQY1toqH0isWx6IWz4jfvC3w7ej6H1Hqz8pHE
         JIABDsGN/s6kQmTvqjZk8mwIPDpqTaFeDOL21hehXAyAaAEU1sgKexLM/aBY4XoEAbvr
         sZjZH7Y0ARfA/1C7Y6JzGC057EoYG3SHsY+qegcToJczZ2rvglm7nZY72ShN/cL8mxgo
         A0jGwDCqNjbaWmqLeYshNyRagcBowJyDgLnLEiyZ7e0pCepR5r8+79yBvOBdP7NRDb4g
         wo1V27VMZhy30r2fYl61Rdb3uLBMdfWEEeLWxZvgsAZHD3/n22i9CdPEFF/BJBEeezev
         8BYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795644627; x=1796249427; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CkBk2j5ivR/mh7ILFij97SNuJfGxESxh8j6/caNV86A=;
        b=P1caqa8E5wJSl4MCiariCYjazkgte0A8VHxq1txvovi8PYDkQliPQSpqjALriQ5tg4
         rn20gaOQuBWghvgwFXbH2YA21O/TNf2Pmj7pLh3A4KnphQS9xvTTRp/pnQUni0/t/X38
         p7iF5QulyPg0TW7GbSVtKoGBsSUY+sITT0RnebXDDdZizJICBoB4ZZP58cWfwngWqmFT
         H5h7n3yFMajx67udYBDwFjmL2KbWoa05EV9bdIKCOvrkwIgVWJ8q4jFlh5XiMjxuuYzB
         HaO0MX/pDB4g0xVEA/srUiJhbyp0c4jCziL4UY0+z9FIE3QOcP92ZkWFyQosS39euILH
         2KFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795644627; x=1796249427;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CkBk2j5ivR/mh7ILFij97SNuJfGxESxh8j6/caNV86A=;
        b=vMiDj19bjApX6dgagME4LWXvjHJYgDOfLRF9LV688YJweeoCY29edF9rP4nh60rp/g
         FgrOGjq+2JIaQKA0gA/0m1taHGLq0TVOAPtIsfq2ZNFXGdfHWpYYnmM1wzPAzOLqGebt
         qbQfewfsnIqmlAtW8HMk/7kmVgizavQWXwzKkkUWy7WXYFKdibMo2hQkG/Ucv6UO6bjT
         F9WaWWgVKRG4B//Zzb7m/1ioxnhsw3CdzPkZxclM4i+K/wkm/WhQXYV7UWsQoBlr9lgX
         kVgAtbf55g/EVDKOQanC2Ucezo+rT1UpJ64VoOX5In1ywiQ3HBau21ZbMyWVXioSQfaw
         ZKuQ==
X-Forwarded-Encrypted: i=1; AL+hErHJXWNAalNAZeW2DyLLX5/bZUKLir6daLfhdj2cHNBzpqxMf3jyt8HFLNXpe2Q6I+ge41H2Yg7vZA==@kvack.org
X-Gm-Message-State: APuU4Z96R9A0d8jTzFHL6GPPfQcxTJh1hLVcVIH8w19pohA+4R/6Eb/L
	iaY4XUJi4JdpZWhJCA9r93ez98j9Iasp5eoJt71FOrFTKThT40CdkwWk3YqYK7a17vmjf5T7TR/
	Xt48I2YN9wun84vA4DA6GqZL7hzP5zQ==
X-Gm-Gg: AZFdTZfjErPz+jtV4Ji0Jx0+1xKe3KqnilBGZwJmoih7sDzjheBi3hv4U4eKePcKm4l
	P/aupToIP5Px1y6YcVDdqtNBsbxHb9I+lNlA0vMPHaxEz0sOhA3PRyaJ4Ype5vZ8MzwXXjB0O9d
	PFhoSZK4sPCVMnHFjjnDhpzSH5V99NTyTkLFMJ4a3j3Mt4IDCBlO1bL9Bo+KJv1l39L08JNIRZo
	0MCo/GbjD1QrYSBOhN6BT3dQGBcotm7211wvgHXlfozxRR6DaPxsY7gwf4jFvwxf38PCEXkrrII
	zApJthWqfOXjHDPO7N/nNwBN6qu8dx0vPJGukGGdaKpBNyYnv0q8WTTJeds+1sZQV4JcRklcPzX
	mY44Z5Fdm8n+1X6Y4ej0f6j1WxEL82as9Oxto
X-Received: by 2002:a05:701a:8148:10b0:143:2719:f800 with SMTP id
 a92af1059eb24-1b556908ecdmr17988038c88.40.1795644627021; Wed, 25 Nov 2026
 14:10:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124153636.91854-1-sj@kernel.org>
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 25 Nov 2026 14:10:15 -0800
X-Gm-Features: Aa3M54o3hTkahzH_49Bjbc7Zx-dgkzZBTJlliNIgBcED_vBed0zNdkBdD-nvRds
Message-ID: <CALa+Y14BNfdWH3yBY+ky1+Sb0YvRzW=gRcKKyGWWaBQkysPUkA@mail.gmail.com>
Subject: Re: [PATCH v2 00/27] mm/damon: let users report their data attribute findings
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B827140016
X-Stat-Signature: mhe7ubwq45r54wemum6ciitdw9qua5ym
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795644628-41084
X-HE-Meta: U2FsdGVkX19Uw5xVsvlYrIXEXCdCQGyOdVnO2KvXSjOZ0SddxkKHO64Gb7PfGMEBY6mm7Siss7RSp1qMYsAYGbmLwU/Pokv9ZVMLFewwT5yadYMtQO8y6iP9aHeCzKmRVF0ei1rHy4szCHLKHjpfK/wqXSbbwJZc+pDlkISMXBQsH7jgIFwRhPO2lVFjioQXCo7y5R+cg4eWPXgLcYR/pGNfAUsZiMWXK1YePTfxrASaXJvoYcUSmqRlsX7Ibe46Lrv4D0Iwi5vXJr7NOknuB2NZg2EQkPiKxgwHurxskGVg6tqR4ChQaelc/xAgw575bL2r8mEunv1uL1xRPg/GFKvhBnNRqCYpt4fDpKoTmbZtuyCITpooR7Gx78C09rkO93WzlCrf6hf3v8Ah48kHhPZB9yK+FYDGjI0I/dKd8z6bAFhk7EXoPF7GtsqdU6jGYDyUSC6yhmyHif2MZM+2taavcqmoRUqF+Vq9PawS8LwdTzNjqEKdsHI9AB25Fejfg+Km/J+Xf7s3xoVmbmVcz3lcuyMjiXTQd6K61dMUCbLpBtC1wKV3PgyqsqT/ej0WgPbrFTlEuySHVjyHwHh2+XcSevLdDBkiLBxqKqCiRCpfwUjoKXJc8245BgvlaLuZtUW7nK3UscywiECdiWkiimbCwUwo9fBMMmLVbd63WmGUGZTpxBEVnP2+EZ8hPUntcKZTkUlETHw0JIfO0B4YgewfkrfBv/VkCURdzkvqfxKmWgh+k7WSADD+KQJZJFKvaM43s/OC+MILehE7iRbkCLouEoHguDGfQ5gTQuKB/OdMdNBISgBhauxoQNPwJvwIJdW/V1dFdXePmf6e5pJKoGV+whaEWtvZeXEl1iUYE42Q0zbmFmz02ph6JFVeZ5/vTaKbyUTnW/IKlV2JJARxr3l30e+bcogHQERDbn+QMfnmbg3jkDnrRtvVBcRh+8g2AXEkcS49sjd0fpOBeeb
 ZXtY2kZd
 uVEu6qhqU29Sk0nMPokpwp2w12ARLlu+mwy9aOQexaipHhF7zwokkmoJnG4Q5GzAlypjROZOpACZfhMgv8VhI9aRP3u0s84qLH3gt4eKcNh2qPCU1yq2IeYxx6bjiOyszJjaHPHC0fyxBeAeICcqrWkr4MxyGCLt/uvHGhy5ds+pp7CqwN8B/OQIwEve2KB1bpt5l5G2zj1KXu84eQDC8SIeAd7nSayKQwL5WsaD7aeMyfGchmNSwb3ZeqLHwV8FYvvLMxz4xpcG0dQBoPN0m3sa9bfIthzG9TVdnLPfO9Ksiw9b+r0wneSro5YTYngYIamWQVmGxWwkw71tIdVDK5XXp6+HknlTZ6voplcCy3bjLdhTHMsRSZD5FOaCTR40wFkLxaFKnjOIF43L/+DOA96sfW2UvhP3bEGYa1CFSkCbIJ4l9esF6+7SX9yU7rsI/IC8abRLS2rIYSPH1IKGchpMyDvuauXp4UaO3SSqM/s4SYzHqdms7PnCdrWWmt26T2JAkJJxfz/M4TQIcoTni+/4Ep3brAWYwozYzx8m6bzcaSciJ7TT5v+vC353Dy40d33BkMBPbAisqUufj5LP1dW6+aEQwLsLk8Ulf1ldHR71FgFAXh44p6KLANk01NAi3ulCjqNd9y0Ot+4dEjJYkCPfgEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

I tested v2 as it is in mm-new, and wanted to share what I saw.

How I tested:

The guest is x86_64 with 8 CPUs and 4 GiB of RAM in two NUMA nodes.
A paddr context watches 1 GiB of node 1, the physical range
[4 GiB, 5 GiB).  Every 5 ms DAMON samples an address in each region,
and the context's probes decide whether that sample counts as a hit.
User reports are submitted through the sysfs producer files.

The context has three probes:

- one with a REPORT_MADE filter for user_report, matching=Y, allow=Y:
  it counts the samples that find a report;
- one with the same filter but matching=N: it counts the samples that
  find no report;
- one with no filter: it counts all samples.

For each test I compared the hits of the first two with the number
they should be, as a share of all samples.

I tried four cases:

1. A report that starts exactly at the sampled address, with
   addr_unit 1 and 4096.
2. A report over the whole watched range, kept fresh by one to
   sixteen writers re-submitting it, slowly and then as fast as they
   can.  Every sample should find it.
3. Reports with an empty or inverted range, next to one valid report.
4. A REPORT_MADE filter on a vaddr context instead of paddr.

The DAMON KUnit suites pass.

What I saw

Case 1 works now: with the addr_unit fix in v2, those reports match.
Thanks.

Cases 2 to 4 do not behave as I expected:

2. As the submit rate goes up, two things go wrong:
   - with matching=Y, the probe misses the report more and more
     often, although it is always there;
   - with matching=N, the probe matches more and more often, although
     it should never match.
3. Empty and inverted reports are accepted.  They never match, but
   they take queue slots, and enough of them push the valid report
   out.
4. On a vaddr context the filter is accepted but has no effect.

Where it comes from

Case 2: a busy report queue (13/27, 14/27)

When a lookup finds the report queue locked, for example by a submit,
it answers "not found" rather than "don't know".  For matching=Y that
is a miss; for matching=N it is a match.  The more writers, the busier
the queue, and the more samples go wrong.

The right answer here is 100 % of samples for matching=Y and 0 % for
matching=N.  What I measured (the last column is the share of submits
refused as busy):

  writers               matching=Y   matching=N   refused submits
  1, one submit per ms     99.5 %        0.5 %          0.1 %
  1, back to back          45.5 %       55.3 %          0.2 %
  4, back to back          49.0 %       51.3 %         60.2 %
  16, back to back         15.6 %       84.9 %         79.9 %

The numbers vary somewhat between boots; the trend does not.

Could a lookup that finds the queue busy skip that sample instead of
counting it as a miss?

Cases 3 and 4: input checks

Two smaller things, both about inputs that are accepted but cannot
work:

- Submit accepts a report whose start equals its end, or is above it
  (22/27, 23/27).  It never matches but takes a queue slot: with 1000
  of them after a valid report, the valid one is found in only 4 % of
  samples.  Return -EINVAL for these?
- A vaddr context accepts a REPORT_MADE filter (16/27), but the vaddr
  operations never evaluate it.  Refuse it for non-paddr contexts for
  now?

A minor nit in the cover letter: the loop
"echo submit > producer_state" runs in producers/, so it fails with
"Permission denied".  It should be "echo submit > 0/producer_state".

Thanks,
Ravi

---
The case 2 setup, for reference (paddr, node 1 = [4 GiB, 5 GiB)):

  A=/sys/kernel/mm/damon/admin
  C=$A/kdamonds/0/contexts/0
  echo 1 > $A/kdamonds/nr_kdamonds
  echo 1 > $A/kdamonds/0/contexts/nr_contexts
  echo paddr > $C/operations
  echo 1 > $C/addr_unit
  echo 5000 > $C/monitoring_attrs/intervals/sample_us
  echo 100000 > $C/monitoring_attrs/intervals/aggr_us
  echo 100 > $C/monitoring_attrs/nr_regions/min
  echo 100 > $C/monitoring_attrs/nr_regions/max
  echo 1 > $C/targets/nr_targets
  echo 1 > $C/targets/0/regions/nr_regions
  echo $((4 << 30)) > $C/targets/0/regions/0/start
  echo $((5 << 30)) > $C/targets/0/regions/0/end

  # probe 0: matching=Y, probe 1: matching=N, probe 2: no filter
  echo 3 > $C/monitoring_attrs/probes/nr_probes
  for i in 0 1; do
      F=$C/monitoring_attrs/probes/$i/filters
      echo 1 > $F/nr_filters
      echo report_made > $F/0/type
      echo user_report > $F/0/filter_report_type
      echo Y > $F/0/allow
  done
  echo Y > $C/monitoring_attrs/probes/0/filters/0/matching
  echo N > $C/monitoring_attrs/probes/1/filters/0/matching

  # one producer covering the whole watched range
  P=$A/reports/producers
  echo 1 > $P/nr_producers
  echo user_report > $P/0/report_type
  echo $((4 << 30)) > $P/0/addr_start
  echo $((5 << 30)) > $P/0/addr_end
  echo on > $P/0/producer_state
  echo on > $A/kdamonds/0/state

The writers are 1 to 16 copies of a small loop that writes "submit"
to $P/0/producer_state for 10 s, with a 1 ms sleep (the first row) or
none.  Hits are read from the damon_region_aggregated tracepoint's
probe_hits.

