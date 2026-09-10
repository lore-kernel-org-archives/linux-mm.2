Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 808D4C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DBD66B008C; Thu, 10 Sep 2026 03:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78BB66B0096; Thu, 10 Sep 2026 03:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A17F6B0098; Thu, 10 Sep 2026 03:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 407006B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:46:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAAC9A0496
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:46:48 +0000 (UTC)
X-FDA: 85197070896.30.2E85E60
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf31.hostedemail.com (Postfix) with ESMTP id C576E20005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:46:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gv4Oy87q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SR/8Dy6Nrrh5LDSonTYCX4wiBWSkHbsQtwOFo2cEn6k=;
	b=PCGn4Z1oEm/V5xKbrRe4Q0OoKjI9ovyHP/kFp0C418ZG2WVDze5SmwP54Eos04JGD3+CrT
	HTcnowB2M8XDkeBeh+pFQMDB1VJhKfEfPpa7ZGa1iGR6ycxE+cKh7ueHveyQtLv702ccwx
	ESf3TbjcjvjEGBfYmlf3yZd/cP2Sa7U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789026406;
	b=SuO28Rvlduevh+2ulioz/42RNr8XgRwHysFU0i3sKa9npkwTGAdt//Q8cMJzRcBp9qZk50
	Hsy+NMPbMyylNa/YpUyaQaxAsC8yFhBY3idxUkNd/MttCIZ1+IFEHewpYJQraipVG8Qr8C
	t2QDjSTYIp3HzTm6dO6r0HjWM/Pr9qs=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gv4Oy87q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b55da9so772682f8f.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789026405; cv=none;
        d=google.com; s=arc-20260327;
        b=qkAwZFMU7FSbFtgtCZ1tUElNfRw/0iMzjRq/L4S0WLTffcmSCnyfsRvWRhCuKtRjiS
         e2nB0lhvPWKqVCiT/Co8Qax/7GhHzkF36br2DoIaXBxuBTo/uCnGYLmdMHPvrq3YeGg6
         Lairzhqhn6tHJIMCw+9C8HKMAOOZCxSXepAfxKd3sFSHXz/W92TP/zGIv/1eOKqfiS6h
         fxWUxW1k27HnPBWmrxwD1c91Rp+03gDglAA85qN0SNLrQ6IQHj2fvHGEgEjXdzYWSkkQ
         m4C+EUsgCLnk7+NRiokWOMuF0YJsQRZKQ0MIUbbR/C4njt1L3qni/Bo/VZk3x25CoECq
         DtiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SR/8Dy6Nrrh5LDSonTYCX4wiBWSkHbsQtwOFo2cEn6k=;
        fh=P4LhZSWqz8FrfszZagA+2i4EANAohkYeH7Q6EjFxK0c=;
        b=C9nE3oSgaTDjOaxnZ3gx6AwlCzQyyzJQeNE/X5giAXucYdWcLf8x4OPGEePY9c6G47
         nBZuQafCKvoDQaTyjUGuTDWqgEQDiyXyh3yfJbWgyIQNjtUOZdTMtFB7v8GcHJHkQ/2j
         mQRc1djb35qbUYIwDhEM7jUWBRTdC9Cm6Dlb3RR+q2Mk/2+6bmCcdePbSFFyBOMYp/5Q
         doji+LsH+8pin+0Yh2N71mmeTkPWrj6npyb0plTfnSd5seypXOg1w7GwC2eprR/TYLry
         J0S6ohGqb2VXChD/mRkIdwrXrYZIXrV3QQpe+RapwALC1K6PlroH6udC6Zqg4KX0OsQy
         /m4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789026405; x=1789631205; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SR/8Dy6Nrrh5LDSonTYCX4wiBWSkHbsQtwOFo2cEn6k=;
        b=Gv4Oy87qEOG8zUaLWOiHICf7uda+2IjkLx4xXgC8ygfR8jjHCKHcL9SSE/u6wcAYX+
         FlgLh5G/Kwnrpip2/b9Nj9b+tIVCswqnlvCUGN86r0K/ft9EkUmQx9QOV1wImqdoAhbu
         ROCHcKmXbpYKqVsWupMoAer0+b4eBeOfAE5ORoCJdrzTGDJ4KLOY9Z61KCvz4fD5LAnw
         mf/HOtbWJ0dzwSj3lNpEp9efEwpFF+lYp34VUNbd+IM7O+IQDhOhBicYBRNZkrcMV5BY
         nFDO935gvk3N7MvDLj7SwAwRxHXHMyrHUMCqQcLZCoz6qTuGHiKU9Azuf5gftvo5Hvi/
         ioqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789026405; x=1789631205;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SR/8Dy6Nrrh5LDSonTYCX4wiBWSkHbsQtwOFo2cEn6k=;
        b=a+2BUFwyRiODNjCdrzpJqy9XkT+xlpc9ItvaACBF9Ej6ILippCtglY0If6FLY0WSdq
         t3GC6euWdhjeX9X5ejxhqCQR//26/B1UmLDE3VxQJHWnu6tEVvyRBdp8SiCA3fyl8Wok
         BmQkQ5yz1O2RT2HCG0T/FUvWUm/D3Vu8gbCIwefEpC2mLzItFJli2CKsnarh9CqY6wkc
         YEuvaQc30OBi/7OlCw8c+px0Lxh4Xb2yTNyXluw/OVKPy8ybJnIBwUBJWb+SysQs1HGU
         Ii6TijPNUwKyeR/5TYjBPSpMsCTMqig59Yvf3f8TMwwmPQDc76wZM6lDTNc2NB508+SR
         rs8g==
X-Forwarded-Encrypted: i=1; AKwUvBx+8U4WpxeC4zkgs6zXX5zzk8GU9H6qeIwXTxcbG3/TPFrbt6CDwklbU+bOFdWIsVFWyDDWhgTD2w==@kvack.org
X-Gm-Message-State: AFuF++lXQq3hJdTY+zZXpiPR35OL1pWxmMyz1/jvsx9AMWb0lpMqaltb
	cCu094GmurLQiM/Ru437bXqWGL2aRwMlf4VtwQH2aifVevTuiXYUiWtJF8MY4sBLfxOvV3iJRAd
	HD+miEGYvGIEBulxEeCgFCWp76stN2Eo=
X-Gm-Gg: AYBFou3Lr08sNgH8SQ27RHAUxLPkYx6CFLVZ+xGCADzFKRNagp10+489JBujuLA6gUN
	qiwZ8FjJuYr1L27sjALPThWg2bEijQ8CTNXHJt4ENzWldziAzd+GoAb/dTpY972c8ub6egtULIP
	Lak9BpYpULIWFCINh6OtkqaSSmqX8kr/LTzMeq1wnwOs27kblFvrpJIZ9LAwL+kaStCbk8kOkb9
	/da/GIX40LUFzccQY6FtlOCtwYRXcMMpJ6zMFWGHZ49Hqt30n58Ta/fz9idd1Uy1+bu6kur/U3u
	dCddBWQB0Z0sLYZJ2sn8zb4fFCrm6g/mI3+ne3hcCrjYQeR4vq9sYkJNHIqqc01kVi52xcaEjE6
	2NkXqs+Q9xjoY1aEktlTjsr8EPT++wBH1o4JG3MDOT/5Cgtu+YDQ=
X-Received: by 2002:a05:6000:2f86:b0:485:82f7:9053 with SMTP id
 ffacd0b85a97d-486d0de1a6amr3798843f8f.1.1789026404909; Thu, 10 Sep 2026
 00:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <1d5ac9d7-48ce-4fee-b893-f646bade4a86@kernel.org>
 <CA+qSx6yjiXJkQm=hi=F8=_=DU0x_usSuXnL_1yuy0fUU9UU-Zg@mail.gmail.com>
 <d3723be0-46f4-4025-b526-e1bb3cc2cad6@kernel.org> <CA+qSx6x2-Md9uVZo+HV0z5CfmGPDzhL482eJNnM2VYVtn_e72w@mail.gmail.com>
 <aqJbFXjU53_D7SoP@kernel.org> <401e3beb-e2c5-4241-831c-005ccfb22e34@kernel.org>
In-Reply-To: <401e3beb-e2c5-4241-831c-005ccfb22e34@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Thu, 10 Sep 2026 15:46:32 +0800
X-Gm-Features: AcwNN1XRAKyh-nKS165ym6trfmmgm5ZhN281YBrKACOabVg8q_Fxhd9PqW2nK2s
Message-ID: <CA+qSx6yZ4R5_n0PvYMvt-vU7CfsM3YEjHxvBz+N4ann=+BQzdw@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org, ljs@kernel.org, 
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C576E20005
X-Stat-Signature: dk6b9wyt4zu4kgorrt1fbdmjzyjy68r1
X-HE-Tag: 1789026406-202885
X-HE-Meta: U2FsdGVkX1/uv3/Iz7U+SD0CgF5uiOEUgkZHJA33XVdWpe4M1SgZfwBCJvkeJw3zPRxsdbFNqYUJHEX0HPx8hQ9TovFsPUTtjr4lKcqNK/5PHXcTB69+uYHcT0NARENIRULHOhtKMUKGY2V79Ga3X0a3PfRtbbTvGs1iFN6QrDnVfNAbpEALAWEFBST+9xvUf/P2F6uHsP1JzUoEvXYnGYtSayKRfam4plavTVN9RsEqVrUoCHDavQElwKFezYP4InRW2m9qxTByhWp9o72QYxyLjZHyvlRN920WXvSlM3njYTRJtmh0ZsSvAOxiITK6KdVaAtgJBI0/hoeqp1aclNcGrdbMujZjgPng0DngSX6l5wy5pcyVe0gPINc/H0bY/nz2zDK8/ExywzFcA9hpiPk8GPNxEOadCEoALm6qpRI6MnIdq6F9evWRcFjhtR/AS/ImFAOa22wlP22KWKmJs5yXB2viRbRkUk8OhHRJSuHMkAZaNmQxwsZqm3GwtYRFLSaQ52kv0s8h8jSe+ymxQW3vG/etVhfOi2BnrM+gaki0Kn4id00NIF334AOLNjWhLdTZcrAmyAm2Kzc2XAxoS20pepp9fN/M8Ez1wgFW5GZZzY5k6q+kivzkcEcpt1FAn6OJyFb8OPRWXs+eRWEyEkW0Z94pBKtmH7trNeykkaMB/DOUXjtF9SrJYmzzPXS0iCoIOQiMiDEp2pUW8YWz1WgohJVPl3lFxKB36XeEW1Attr7fce2R621IZLCz4IOp3EG3obY+EFbNTs14iHl1XjYADg6572XNoK5ploVmZxMbFTTSCXHf+oFclWnWGjCwi8cH0aW8SycLGLDrkX+vI4USvZzHDPj3IM7nr9vPe2uOY5nUTPBYblZFR3cHM0WzRD1OS1167GVKZYkbOMNgVdl4CE7kCq6g4BDbH0TNpNJLW2amJkClpSFg8BRLRySlwEvVygJ/8zvu/iHfb2/
 8tyjUxF0
 3kL/EpBmwhqnVdzigtXsLfthFpVZJMQT+lyW3ysxdDUXrBOsCqTwego/J9pj09rS/qhfkHBtS3Obl7V8xBCTquZ/178+e9BR1v584tQW4iFulrjin4bzwzUbjSQ63pVQV06n3w/m6Vn37YxqxXcq8/Q3KwwSH55hMuHRu7yJtIRYkodk0lxNzEQUnLvvOPKdDzINaFGCdLyj8pdlzzXijJGd4M0djtajEHF4W1QPS1kKRdpKdnXJk7OfTxs6Ozk4+rd6Dktl5HvOOT19/ioMkXgJitTFQD1X+ctCC86TzvgEswsrBd/+OxnVQ9DaBYD5NHSYXuh0E9g9BIta/t3OEvtOKJlcYm1RqNNTw70sI//r8E1Yjdi/yKqZydeBjlKk9kowATz9e6Y0iJNL7ibeVzQvHpF3EDroyc4ceCRF3wThX+dm7oXlZJrnDL8db//ZADZRrMQeeqxnwhhmMhUMGxlV46+FI/YkbNfR1N1L/hCHKcRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 3:33=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/10/26 09:24, Mike Rapoport wrote:
> > On Thu, Sep 10, 2026 at 02:22:25PM +0800, Xueyuan Chen wrote:
> >> On Wed, Sep 9, 2026 at 11:18=E2=80=AFPM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>> I think getting something consistent for now is the most important th=
ing. :)
> >>>
> >> Hi David,
> >>
> >> OK, I'll move the highmem check into set_direct_map_ro().
> >
> > Consistent means leaving highmem check in the caller ...
> >
> >> Should I also update the x86 set_direct_map_invalid_noflush() and
> >> set_direct_map_default_noflush() helpers in this series to skip
> >> highmem pages?
> >
> > ... or checking it in all set_direct_map functions.
> >
> > I'd keep the check in huge_zero_init() in this patchset.
>
> Agreed!
>

OK, I'll keep the check in huge_zero_init() in this patchset.

> --
> Cheers,
>
> David

