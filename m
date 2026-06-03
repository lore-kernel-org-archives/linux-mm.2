Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C24CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9ED86B0092; Wed,  3 Jun 2026 14:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E757F6B00B0; Wed,  3 Jun 2026 14:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65066B00B1; Wed,  3 Jun 2026 14:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C571D6B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:10:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 687821202FE
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:10:24 +0000 (UTC)
X-FDA: 84839391168.21.442EE67
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48C13A0011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:10:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=p3oPuiz2;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.52 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780510222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
	b=fXJPsZMU014rjWybPRHC5JGDE3KOn4XFS2WS1fhKDL4DKJFUMcfo2USXTKynDBTQSNSxav
	WjyldPOhlJzROq1xEz+v67yiVO3iD8bpyjWZWMXlFwRaTuW6XtazPnG1A1EVpnfe3pXzuV
	ehwPfH4vgxioOqEYh2U0V/4Vlm0N6p4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=p3oPuiz2;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.52 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780510222;
	b=htQIm8fD0NVd/PGNkDJxvL3WMNrd1t4qQGaaH00GrwenqGTKGON1AwZmhhZ9DBy046gzKy
	xh8wcE8WQkEu9OqNSO6NykaBDJ2Xl2G21PyN0eiGBOx/DSrT/fXhgt277MdcVkQubDPxNe
	7qWGOb+jfkx/QJGui7FLmswhV/RlLks=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aa61e3d3f3so4524206e87.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:10:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780510220; cv=none;
        d=google.com; s=arc-20240605;
        b=WtX0ZgHAxNNYTEWreJHT6TA0Bi97sLNGwmOqHv7DZzqczRQst4c4fl7rE2HY1zYNdl
         dx56Yi9lbeuRP7oK6j8LWJtHC5vVW5fm87Hc6tqs8lZAN3/e5S9oSrSDmFFCXUPwF3ej
         +V3OH2YY0YzTm6ImEHO9dIgy5SftsElrZ4421fT+pKhsA4+5oAwNzr9kMCl1R/LjAoVI
         1OnRw8v0DP+1yAsNpCJlGAaNKhgyZIZXZo63X5LKAqP90XrVuOW5PskuPzTzGY9K5KNP
         eEwggAKZS5A0K43+F3JgwL82THRzK7cNFLti984a4q0CwgYDYki68lEdAvdrfA35oanG
         XfEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
        fh=6wwEICP+aPEpDYwINFvS2PDOP7USxVxNjPw5ZyItdkM=;
        b=PMcWwNiGIpCKnPjpwoaW9rQ8twG5qyrMJWvDwPETPveuO6lzgWokeH9EvHE6PybTO6
         j/0EOXDT6vLPJjaAVQC943+IZbrcoxFRoAgJYBUEREo8r6rjmjRCmWW96w1kI6YyoMXN
         IaGHCOnoRVidMRH+3bMMQWaVXFP5nOTPKycrq0eiaR+utp/bVC2jLyHlXvdVejWC5qjR
         ako3rXrKzXwHCa3nDPMLzTgCzhZcqh2rQp7nbG9kmiYwenQS2NYAKe+PVtmqBfuNSqcH
         lxpHl6X5e32zBEqJrFnWf4jxjmjCJt17mFbuKwCAsv92k1qj+DbEpLBiNpT1VLq7h6bw
         VL5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780510220; x=1781115020; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
        b=p3oPuiz2C7ejjWKj+6LnGRn98GQ/IiWAoaMfd01lb1ttWzQg1f7Ev8UpKr8Y4iASGl
         MisQsvBx8oegpUXttWDT+Hpksh914GDX6BFqsim5dWJQu6RQocLIavZNJ0/0P9NMYLj+
         7cEU5nYIRapOkTmWsV6GzOrWb4I1eKaTnDT30m/keRDCWCVgabkWTRWZhsI/GEXaKyfI
         u5fid9HM0AGeWzSyNhms0j3kX2Z5uuZdD/kspC1iHxtw2mm6jmZwLy7kTTERvps3eA3M
         /N7H30UYfzJD8QWdfFJGpAVRtuselD3oDXZGt18Zw7NuvE3SPxtoGWFdE2izrTw46vUP
         /RBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780510220; x=1781115020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
        b=nsj8tWCWjdWNZD3nO7hEbHsNxnfHW2rKLVwSodcGrHGR+rnB2n3BF5Xe8XV1dMj2jr
         MfCznYbA5JTd7VanxHDecOP4b+Cle0RH8CnWGWH10Iog8JwWs25MaiZMNphLe/pFTbUp
         ajX1EAOaE1sRBBaIWBKJBPHcygO41X08vsGTHVcj2dFsryU5bX6yzdM6V/4M1xk5dw6c
         f7B3lXSaaiPWz3/XQsPRAAbHJGCYvgTsOo5kqNatAAhUPUTT32ykxbJEGbmhDV7Pm72h
         g7YClKFD2MJXixpJgASg8WORnSoxM+v0bUQHgNGtynAbLMCH6H/0do1HNL2T2mBKGfwU
         +cQw==
X-Forwarded-Encrypted: i=1; AFNElJ966lHcEEfdmq2c6eL8umaR/fN3F+oDPGeUOCc9JXMismcqiGuvzZT1svzCikEZg9+riQ4/niH7RQ==@kvack.org
X-Gm-Message-State: AOJu0YwZiAD9p5Ov9m0GhVU9IH+jatKXr5TIpoafV5R84zLesEwfYmBD
	gbjfJ2VJA5P66qWEFR95uslzuFF8S7QgvUWYxzqW8lmNonBFA4S6PeDJCRbohyOIVzmItulk5jq
	8DUyURivKhO/34w+pA8UWPytgrQeysWbLRSceFNj4
X-Gm-Gg: Acq92OFD8bxrY78Pm3mbdBvIRm7K7P+oyIh7ZaiLlX7ncn35mL/1aXkYbWOseRSM8os
	Nf9EeqDeReywYSvZy65hgKzvN+7WR2rlMhLAKa+v3xmCOim+TU1FSGTy5XfDdSjD0UC4Sf/a1ci
	U+om7ODQfYyU62Ekyc/2Z7CwHLWE/0VjiUk4aXHcjaUMN1HWkwBPsUC0zQ6jkvG0IQ2lPES6CsZ
	FJl6ovYRNesZ96SSCKfVexXhnfV9SLoj5dFgExZ37OCTcPZKOFSxie3M5/7/MSL2vYMGqEqoh9J
	8D4xqLfvwT+TkM6zDoQ=
X-Received: by 2002:a05:6512:1316:b0:5aa:6917:da62 with SMTP id
 2adb3069b0e04-5aa7c0feb48mr1695669e87.22.1780510220289; Wed, 03 Jun 2026
 11:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com> <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
In-Reply-To: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 11:10:07 -0700
X-Gm-Features: AVHnY4I8xlGMoYvHWadfAyp7JPxqtCaCokQuJfO8Z8xN2WDEFYt6TSKYy0-h7os
Message-ID: <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q5xp3wwam8agjjsghccwkek94eampn93
X-Rspamd-Queue-Id: 48C13A0011
X-HE-Tag: 1780510222-189130
X-HE-Meta: U2FsdGVkX1/CKVCr7CryqKrVYW6G209xKM+TWIMT7g7FJjNX2Fqh3JoV4sVxueiULX8sume6Iam7FeUohc+9VBBjelpwjIMc4rXRbKZDcm94HCEo0bCpdzuJuX69UljTsbGJypg9Z/ioTcnuxEMT9Gdkmq6XXsikEnbRBtjyb0XVTOIc031AQVNWlYQEezaFptxFxdSVK7YrIVjuvnxY5QCu2yg/ud7bAG70F/9WHaJAt6XpnlI2+iaGnangr5dgkE5T1JR3XQzt2jGPjcPZqxxiVw2d7n9c4MVY2JSpkc/bmFgo4eDSnxS67XAXxz7JZefQSQrlV4/XBx95jbB8XpGNzLQLPfJnJPV5fTV/K4Pr6hum+mhPvMnGCgqIXTAKXRUKoOhpBYhvN+JriD6Le+c8tja4/WhfWYNdxscCDky9GNTZZ2szTC/2o8HB9QwxiekK5Bkc4RniDJE1vx6ynMoNekIuxvGPqEUHYWtsIy/LbrCxWEA2IE/3u7xmVmxsKesRaDzwGb0Mo+jKgpgWGZGtHP2PJIpY44eWIq6eC06FXYQxlFrd3ryvlhifpuahS6mpai+ItGLCtCloyxAWBL5k6tQZnwUHEUUV2RzZZfS0s1WhTSaaFmVIy8A71tILIT1k/KeK0znJ8PFase+R341aEMRN5nFVSfLacuAf4url1u/b1/gLShlXaJxQunPCA4fhl2LVdF9/nYf92D21RxgOM9gD7uQcMspjC2LvsCKHY1+w5H2Pe1wpf7uyPMGnFrYbP8ArDOxcVnPiIXiOZ7R5BqclDm/0Zg5Nyia9RJ/pPAFefqxpLCo1QyoK/u2AFZ37megxlhvfybK08Cqgp+Lw37Vv0ruvSalVXJOinpK/iS+sWOp5RriWOv/kojDVWAGODnxN2xRXhWIQjbp40/rK5hgEgJ5G36VtSwVRjAPfwsamLcDhQrJFa3xqVi9Osf92cITreeQCbX4dQar
 2qr+N0C4
 kfNV32VS46Xz3A9k5l0AT/hJ9VprVErPWj+h902ptqM4R2cV/Jlt0nig+jCWtfPRgMpcoiezwim3PmI7/nWyvGH00UOLDTlhWlfL5YKmNZC3/Apbgdr7HHxvVkplvYHbAJdScbtr/TZFngUawRlVB7+Vt9N+XRtSpJI8GqJwkdb+TwdQiw41260S4Wl+N0pJ/vW7F8TtHqY9JMTozQ3Wson8yhdw5eTIUFu+jAgYhDj3u+FuA6/DzDeLP0bZHREVOC0sAUGk0BnUx+bMtp1N5XJZa5owoUG4HS0RWTBy9k7GGDDUjwK3xk6iAnD+TB86t6YGZFylFBjiBna0Vm9laVeZyWB9Md4dKNlg++XZkeL1h3NPttPdXH8PfwAdQqTwKb6JCbH9hsnaObtR++1MjepeVK9zlziCHgq/ADzUF5XJrGxZfSmlwa2HADsxJtEwiLU0i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Jun 2, 2026, at 9:20=E2=80=AFPM, Linus Torvalds <torvalds@linux-founda=
tion.org> wrote:
>
> =EF=BB=BFOn Tue, 2 Jun 2026 at 20:51, Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>>
>> Am I understanding correctly that this will completely break zerocopy
>> sendfile?
>
> Very much, yes.
>
> And it's worth making it very very clear that ABSOLUTELY NONE of the
> recent big security bugs were in splice.
>
> They were all in the networking and crypto code that just didn't deal
> with shared data correctly.
>
> So in that sense, it's a bit sad to discuss castrating splice.
>
> But it's probably still the right thing to at least try.
>
> I've seen very impressive benchmark numbers over the years, but
> they've often smelled more like benchmarketing than actual real work.
>
> There's also a real possibility that a lot of the sendfile / splice
> advantage has little to do with zero-copy, and more to do with the
> cost of mapping and maintaining buffers in user space.
>
> If you are sending file data using plain reads and writes, it's not
> just the "copy from user space to socket data structures".
>
> There's also the cost of populating user space in the first place:
> page faults for mmap made *that* historical copy avoidance basically a
> fairy tale.
>
> And not using mmap means that you have the cost of double caching in
> the kernel _and_ user space etc.
>
> So sendfile() as a concept (whether you use combinations of splice()
> system calls or the sendfile system call itsefl) isn't necessarily
> only about the zero-copy, it's really also about avoiding the user
> space memory management.

So maybe we should make sure that, if we go down the route of
disabling all the splice magic, that we leave an API, maybe the
existing sendfile or maybe something else, that does an optimized copy
from one fd to another and that is at least capable of sending from a
file to the network with at most one CPU-side copy.

Even if we=E2=80=99re just doing that, I continue to find it strange that w=
e
require that a pipe be involved. What=E2=80=99s so special about pipes that=
 we
allow splicing from file to pipe and then pipe to socket (this
requiring that the pipe retain a reference to the file=E2=80=99s page cache
structures to avoid *two* copies), but we can=E2=80=99t splice straight fro=
m
file to socket. Heck, even sendfile is implemented under the hood as a
pair of splices!

