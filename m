Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BFCE6F06C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 08:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE0F6B0005; Tue, 23 Dec 2025 03:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABA26B0089; Tue, 23 Dec 2025 03:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D2C6B008A; Tue, 23 Dec 2025 03:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6807D6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:40:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB3C1604B6
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:40:40 +0000 (UTC)
X-FDA: 84250089840.10.8148B51
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf04.hostedemail.com (Postfix) with ESMTP id DD8CA4000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:40:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dVXroVqR;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766479239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUwtgrMapZPA5zIKs3/MUFaPRl4dU3pm9b/uTBHe6g4=;
	b=APcJTy2x00tHaMq24PC8TsHVyWiKYnXLuXNIFasS6LJKZS74fJTt4LGPqcJ+GTQQB4RF6J
	GLcfHTzVkfYEIGw7mraLIg3gqppl8h+3evc5BuTK6HJ36Zb4IWfOZxNjn40dV1H1KLKDCC
	FNuc7ltbfTRPJDG7PYBrieBwnRscr2w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dVXroVqR;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766479239; a=rsa-sha256;
	cv=none;
	b=XpufN2iMZ1JdCdNX+HBsqGvXfLmIcGNYc6owmMeuzTT4ur/OmosFNJgdR7H951nrEjzsuD
	l6MR2TYhC9973Ga5Lb74+DRboTd6ZzvalmDEp2YF1VaW41a+kpecfGF2UHUMRVOyMEsLqj
	+6kW5BmbK/AWpYgVLukzimgN78MTl+A=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-477770019e4so39841595e9.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766479237; x=1767084037; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUwtgrMapZPA5zIKs3/MUFaPRl4dU3pm9b/uTBHe6g4=;
        b=dVXroVqRL/iyHUa+NwyU9K36asq2uQkojXEXsP5o/ZiuCyVkX3v0SM/+HcX+2jHy9h
         1A1aGH59isdI9K5cOClmVx7RE/Hm6Vf6NOpdvA4cVryMl/LDbROdRzLM3/0eR8CHkx5V
         /XCfp4pIdh42n0FBlz3ar24IW7cDDuBjyDYin9CipcRSjXcGguGEUT4kPbF7O1Ops26W
         bZoTLzaoVmTZoMngHTcRM9l8M5MeXMGgpGI4HZZrlCY0VdyAyjo1gBX0UxQ8AdqY9TBR
         GpgZ2O925nyJfmj4u98DIfiZCjZDUpObVSwe12yNG2n3naqZXDvmzeRPrep6c71Gmy/X
         dr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766479237; x=1767084037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qUwtgrMapZPA5zIKs3/MUFaPRl4dU3pm9b/uTBHe6g4=;
        b=LXj70QyOzaACPETgIiHxrMtxwc+QajMYhNMEbYhU3wEfY8ivAY1lA7kTthV89l9GrZ
         dn9dxeCNnjC8OmjlWahvDJXyCdbWDOS8W67XnRQZEa+yuzuzwqAJmBsegm7PhhO6ouBP
         2Q/4HocjtdDIZGxhMtx7Xge4WtULUJ5kJkXfZTA9MPjwjLt+lPEVeKuEK9rOfDZGTRXH
         e0h/Pkg3ffyKARW56mUiGQWmvaOjdjc/Kp3opS07ii3zkdTiF5sz7wySh+abiKzsCg7s
         WSQsTFVo+nK5/VerSR5nY7X2dDIinqg9BLueuPMqT8461XJ49lwnEf6kcUPrw44qOCAw
         XOqw==
X-Forwarded-Encrypted: i=1; AJvYcCUfObps1+1UCb2E7fIv7xW2mBpxMqI0A+fsgYJAKmICTXsIYE9c+RvyBo5Es1MW20TueDviD1WaxQ==@kvack.org
X-Gm-Message-State: AOJu0Yzr+nSjRrq6zollZJu+1ZaIWqy2kbNeCPe07pAhDZ8eL3ZsZlXp
	CXjODCOmkKwIYVk9UMdEy1GbnKm+AghEvkHSkIkK6MoNSaY2eNmrmsKc
X-Gm-Gg: AY/fxX7xc4p5B+mHZE7moQk/hoWY2P/Xj14CQ5BHoQ0P/V1y8aoY7l3bJpascNl+YdS
	1Tj9bfQJ0b/3JowbmZC846QedPddrXu2K5+LbEmEfBB1fOGnILGRJIRVMai4/oSvbPvp3gDh/dG
	UvDYckhR9AMWNiE14truTX/wQWXoXb2EeZeQdJ38zu3x5cZozSt9RYpYNIyDlc38sCEnKd8U5T2
	GgpPhxsDoj4D387qkSLa883fQ36u9TVOGWogPCePPbtk5HdYnCikEICNjeLwG/FSzJ6RkYKlecT
	LkWsWR9EfOI9BILbPXbji46FfE+At9GNeeRuMGGVl9TkuUNwOz7F0uTv407148Gm8eXs+D6Zrv9
	3Je9wd/6D1gFH8LAg620dy6PYHZ7sQNS6SBG+yGemtq+NXqqV13q4g86X5gz773m4trV2yIZKwY
	XxxfWEypIm5SBKFKU2mKC0+8j/ORdZrziBQAPUHmHlBk/iBJ43vqo=
X-Google-Smtp-Source: AGHT+IEpteUBeVyvK/GkVobHH5hYn/GMx0SLjKyrRDaOqelnxJtOqBWZOo0NwrW+rNFfDjpy5x73Jw==
X-Received: by 2002:a05:600c:5246:b0:477:54cd:2030 with SMTP id 5b1f17b1804b1-47d1957f707mr151767255e9.21.1766479237056;
        Tue, 23 Dec 2025 00:40:37 -0800 (PST)
Received: from pumpkin (host-2-103-239-165.as13285.net. [2.103.239.165])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea2278dsm26831637f8f.18.2025.12.23.00.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 00:40:36 -0800 (PST)
Date: Tue, 23 Dec 2025 08:40:35 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Li Wang <liwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long
 <longman@redhat.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as
 size_t
Message-ID: <20251223084035.67ba1b76@pumpkin>
In-Reply-To: <CAEemH2dZ3DxDPWuV1Uze213CqoFHec9kK+MeteigGANYTUzbqA@mail.gmail.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
	<20251221122639.3168038-2-liwang@redhat.com>
	<20251221221052.3b769fc2@pumpkin>
	<CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
	<20251222094828.2783d9e5@pumpkin>
	<CAEemH2fsAmhAkGAQb9rtD2WLUc7QMb9Q5dusG3S8LsJbNKsO_Q@mail.gmail.com>
	<20251222180509.b12684e112195ac3f7ee9389@linux-foundation.org>
	<CAEemH2dZ3DxDPWuV1Uze213CqoFHec9kK+MeteigGANYTUzbqA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD8CA4000F
X-Stat-Signature: d8cu6gxhgd7hh1rxpxaao51ycaz4cqnm
X-Rspam-User: 
X-HE-Tag: 1766479238-983238
X-HE-Meta: U2FsdGVkX1/2JmK65SxZrFbpIUROwWWZXPiSlMDEhrVd+pV402d6npg5detLC/ju+BiT2ixK3X16YoFz1s7uMbp90lfe/8mr3IpA+Ed42XI7133bXbnHYyZxSgFEi2TR0Exxgc683zskL+KBmPTzFfcUj7ZUhdCgk6gvbbdkCbtavFxFGmsS8PZntWscDSsc6B0FcKBmH5BwMzICCOn3sVXMqvu+4tE123CabeMBeB+NaeMwIv1F71ZixNXsDIeZeVmMKxEPu9qAhdOhcLgTyJ+7pERH09JsyODPGzmNXA39GCZhNDEHOIWadkmuFAM6/96Flu+6jnhfRNtDhL+0kIt7A8rUdxKPMRT+9vjAWR3X8zxjJhOd32VELQKEqUbyDLF0TJJadmBmfkBFi/oyJA5LDaJES80cRJXuYrbICJQLn9j49Xi8B3qn8RkuGoq6ACvvokF/lC2oNVI06mEXkuAHnCogbG3sm0k9yWDn7aTUhKxoBR3woXz691WCcNwYOCk2X9RwkoII/MkxtUHPVmtHqA3507gQozzVI60sgxYhKDeIm6lP15yIxQ8+rpCbhdElc50p3yUBjdJ96bFU9hlvCE9j3GeBhjmq4uyuFHSX9mt4MCCFpQlMkXfzHdvlUpMtob3wlnWSLwdnjJ+5PujyLpQt8vuZOf2BkCm0gGv1subdwILjK3+LQPwuXjC26+w4YajS14bsVU/TEMsUtc+k1TF+uW+XTIE9NRVCzvXP3i7wCcfiO/YBIA+p6mfs3yjmCpsAVfSKHFk4Ow0vpnc8LjlQ3cHH9tdroo7OECvcsKsBsRBRmGDLOGtAv5w5SjnmxKkZCQWJQ5SDHZfEhBCiqqx/6NYFFsQt6/pk2z0IwHrS6IBNSt1tbIGll304U9Jj88wCZb+gzpCChno8CpXD5KOY6jVnsmIrb1rWpsGBk30XDL1YLQ8hS3aQsYJxFgSEzOJT2KvQSgmAD6v
 LgLRJ0Um
 6RYfH+pSjKPwzFG656rU9mzY9cE9M/A+sxMc9elVMZP8OHq24dqbZLU3KDAzrjQ7mr+DCSMgTO8rYgUqv3spT0I7K1C8IH9HEWz0kjMzDC2sWhF/q3QIezQe6kSpAm/9nDPwFvCT6sypCydWQd7Yj6jNJGAUCdodiW5jaBFk+aB+N7eYqZtCYUPijapqOsRONBqihLwRJdDJM2JDHyZXpVUs1JgDZDQ3eJuc09xPF0zVlsyDMns6M2KJ632vxG6rgEPJESPT6ZxZgnujfvkRqIPm7CBL3g5cUThYejo5T8eMNBizyD8lVIxpeLnPpru15ZQjdOn5VX7VQbJdCG5rgKDiLZw3sNNx6MOfGOMXaUNHiUWG3FlVSovcX+HmwZ66sD9UslypEByJHw9J2NfxQXlUfAb9dl7kkflrECPiHNDGv5ValDGdwC2yIufSKUovia4aLkhaZVbH0ynpNG1oUaHsU+VjHZYvP9AnIP21hb8sEw/gsPakaEMHC3xapy6mHFMtzS3htejVQqYEds8cemYdybZQcf3Scick4GSYitkPkCj7EnT6WsZYc0nYWzWENfte+upVLDJzOKiThG/wwP35ttN4DygeVI+oRaBjSbs3Dz6uQ1JFL2QRRT/DlIEex7+i0xuPTUBVyLTg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 10:41:22 +0800
Li Wang <liwang@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > It is best to use strtoul() and check the 'end' character is '\0'.  
> > >
> > > Hmm, that sounds like we need to go back to the patch V1 [1] method.
> > > But I am not sure, @Andrew Morton, do you think so?
> > >
> > > --- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
> > > +++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> > > @@ -86,10 +86,17 @@ int main(int argc, char **argv)
> > >         while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
> > >                 switch (c) {
> > >                 case 's':
> > > -                       if (sscanf(optarg, "%zu", &size) != 1) {
> > > -                               perror("Invalid -s.");
> > > +                       char *end = NULL;

Initialiser not needed.

> > > +                       unsigned long tmp = strtoul(optarg, &end, 10);
> > > +                       if (errno || end == optarg || *end != '\0') {

I doubt that use of errno is correct.
Library functions that set errno on error don't set it to zero.
The only test needed there is *end != '\'.
(end == optarg will be picked up by size == 0 later - if that is actually
needed to stop things breaking.)

> > > +                               perror("Invalid -s size");
> > >                                 exit_usage();
> > >                         }
> > > +                       if (tmp == 0) {

No point checking for zero before the assigning the 'unsigned long' to 'size_t'.
So the result of strtoul() can just be just assigned to 'size'.
(Ignoring the fact that size_t will be unsigned long.)

> > > +                               perror("size not found");
> > > +                               exit_usage();
> > > +                       }
> > > +                       size = (size_t)tmp;
> > >                         break;
> > >                 case 'p':  
> >
> > Geeze guys, it's just a selftest.
> >
> > hp2:/usr/src/linux-6.19-rc1> grep -r scanf tools/testing/selftests | wc -l
> > 177
> >
> > if your command line breaks the selftest, fix your command line?  
> 
> Yes, I am ok with sscanf() :-).

What was wrong with atoi() ?
Or, at most, strtoul() with a check that *end == 0.

	David

> 
> In fact, write_to hugetlbfs currently only accepts arguments from
> charge_reserved_hugetlb.sh, and the way the '-s' is used is not
> very diverse.
> 
> --
> Regards,
> Li Wang
> 


