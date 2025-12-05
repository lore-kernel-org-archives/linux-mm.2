Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DE4D374AF
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA7C6B0301; Fri,  5 Dec 2025 16:56:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79BB16B0303; Fri,  5 Dec 2025 16:56:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1416B0304; Fri,  5 Dec 2025 16:56:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53CB56B0301
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:56:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA943C0349
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:56:38 +0000 (UTC)
X-FDA: 84186777276.27.7FE0E39
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD3C410000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:56:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VjFFAjA8;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764971797; a=rsa-sha256;
	cv=none;
	b=PrPCo/v8Kng9gkFTqSoJb8yyZdK0EZgLL+1U4MXw3sIEqxPd+56mh6QfdJflrohtMCmCZi
	Y2UG7U+NpIZFSCULEFfrVsj7jjzH7rBofejLdd+xFnlbAl3KDcs0JeqlGMCfzM9PNRIw2h
	ROptTsxEfITuCdEyxifEi86Mud/Cs80=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VjFFAjA8;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764971797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YS34/ZTuIKBhwuafrChCxKoiQzvczG3OxfmcHipP46o=;
	b=uD89gaGpRRuTLsaFHdq+Wan4aPTddzwdGSt6kQ46s7omDIahliffY383psoVWlpnueDgdL
	6xpJEAf6njg5h45XQiIMC9xws0ph9zsAvShhWebPYqV05azMvGhMaKSQLiGfC7NoBH6vfv
	ExbEd67AIRib2HekdZRgDWgm1JY/vSk=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7277324054so365265066b.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 13:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764971795; x=1765576595; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YS34/ZTuIKBhwuafrChCxKoiQzvczG3OxfmcHipP46o=;
        b=VjFFAjA8e/dg1/NTcOstvkatfnIWAngayz/dAoQxPfk/9xZVmEFS5QXdkTfAsv4rRC
         HDPpfjcMHULbIledx36bnYtMZen4QnYkaM6jDyfw9U1j2EhSCGgg7hf9dhqm+sQkbZwf
         t6XlcSI8Zzluf3UxT/zEgMGKgfgJkI27STgCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764971795; x=1765576595;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YS34/ZTuIKBhwuafrChCxKoiQzvczG3OxfmcHipP46o=;
        b=WAv71mMpfhVZBJz5HeiTs/+u7YzpM09hWdjSop8E3h9jZWWjUH+xk4wLMreGI5+YAd
         0V/xtrW3nPtA9H3VRHfY+uzKFUQNMsHf+4KxXZP2br636wxvbF+PjhSoVwvyaI5kK5ZW
         5N5JAqoFnLratI5rW4wwvqCLIQcc/8F9j1fy3XPGz74hRzGpziswGihHttxcgcu+XVaY
         KvLCrMRNQAFNznMhsQqXkc5bHWCllEydZ7ewrsIJ6KMunTedzH+rEKWeZFFwZNVKseyV
         UDjibjpZk1LkLrLHEI6i177T1h2O9PIUOECmoBjFyaAeyJyOKFnipcs8VXLC+ZScoyQW
         sfnw==
X-Gm-Message-State: AOJu0Yw7zh92INBQ9v/bkIioqWa4gZgwP3A/+8VPnLhV2aIoHJqklMTd
	syt0Us4B3061jZ7H2HZ3SdTxcJL8lf8/yt8XGYd/CU/Z8H/uDKo7CwsW5w+dKcLAx9KvEVT2IvC
	RI75Wk3XG2w==
X-Gm-Gg: ASbGnctC3+jdTg6ZQFBN4sKb4AOga1z9tzmk9N1AR245dvCFbY5AG9E5fYR5dG0oLOK
	3L1jRbg+AL1yhkDeP2dvl/RUa8u3ydNDEdPFa+xb09VkE1cUy4xwu1ZtZaEGKqaChvlZwH7hFdG
	viQMoanTUfk7A8AC7VIEMu0ubJVK7fWZmpogBgUYXCvwwvi3diEc9ODan6Mg55MdgbwDDhBK7gc
	Iwh2Xs1T1GhlNyLtvkPE22YCvKB+riocz0Wbf5N2f+ZpoKH08dLKRic69ZlQ10fXesDXCgjnhRz
	9kkNEwyhzdYxvgdXFE1IupeSmPnrzXsdGw/bBvy5ENvpLrewtWkJikc1+ZjHbPOzegz76EGcLsx
	BuEpAtgcadkNEkdWXzfxmAQ5h2CdfNlRcJPV1dlyeFINUCtRWKQfamggCrAM6Q1DeV1Gxt0jB4s
	FJb8+vvcEm4jNXVz9Q1dfA4xjEMnavdd+Kcjzdzi5J9hdlJPOuwuvNfau+mF/K
X-Google-Smtp-Source: AGHT+IFCkBaIgCGNer7DXRXjLTIN5tzGo+RyQWy6N8m7GlKs8ym++pHcVb/Zt7tDIxKodB08X/LeNg==
X-Received: by 2002:a17:906:4795:b0:b73:6931:558a with SMTP id a640c23a62f3a-b7a242bf52fmr67190466b.18.1764971794938;
        Fri, 05 Dec 2025 13:56:34 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4498ed9sm461823266b.16.2025.12.05.13.56.34
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 13:56:34 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso4559876a12.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 13:56:34 -0800 (PST)
X-Received: by 2002:a05:6402:50ca:b0:640:a9fb:3464 with SMTP id
 4fb4d7f45d1cf-6491a3e15e8mr281045a12.7.1764971793872; Fri, 05 Dec 2025
 13:56:33 -0800 (PST)
MIME-Version: 1.0
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
In-Reply-To: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Dec 2025 13:56:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com>
X-Gm-Features: AQt7F2raveagspIXcILTjqryWuFYBWky6HLhbYqsd4miy0ZkeQl0CmPr-EtPev0
Message-ID: <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DD3C410000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: con3154h8jj56tmqajpy8drupc31bwze
X-HE-Tag: 1764971796-55415
X-HE-Meta: U2FsdGVkX1+ENbaQ5mlu9DA1JBNG4xFxx0bFy4NUgGOfwcLeQSW7b8EGatFFZx8oxtnaUx4nHkc+0Vv0OcGWwGAEzZQIXz5Mf/aTmlCFEk11cmDVXLfQt9wz2u+8QqFBD9DvDJsraXRU6TPiQjBA6kihuqh40ObAiclifH0yINGP2LQa6GMgoNEV1HjGdMXk3OK3jRBv5wX6XwFAeN2tKOp8BgZx+xtNPsQgGvroAMcmpRAdMgA0h5o7Glmiy6w0SGypZLnOCXbu7bJoZwBMJ/6Oi1ide6rClEfue4G8I8GiPm5b6UfZSlGu4LWm1O/Jd1WXu6u25iUYfKuCoxlIGKhSVMEJb8D8KxLHAJW6rNyQQ0PJ/lCDRn3pohZWYqqkx16PISU2Rh+czgkHjRTeyYmLUBLXnOMjUtCs6qGOHPyoTuTwiMaoJHE/pTS936IAn2KwI8ylYaJDpGvate8ROAW1YMpyVjET/2hSeg2vArsQIm2aFj33MXZSjKmkzu5kUnK0qAax2iAVb45aPnZMP46X4LAFm73HkFKH2cFS6aYtL07iTWG2+gj4ZNpnNO6wfjmbg5qVMEL1rOL1GMNDDC+BmbJA96TKPFmwbJFdGOmHf9yE44OIL61NGAwF+cT7faX76biaPpYFg7cNj6E+c4fYxETy0s9lJ2a0bRjBg5kDSQDuQ7+7NkoSHtGz9kCzLFgsQltCVtPYWnN4GiZhCIIg3YZbd5/KP0chuae3+9xgJe6gBzJ5nhSFCG2Qn/EXGjpR1rvGPAJzau0nCembUnOJNTzj/ym8ayEWZAKlSaGjUebRE1h28/l9YG/eiJF94vdVo7SMK0AdZX1ONiiABBBkWqSbD5/NtdzuO4yWz1I821M/i6UGCHVYxfcWg/HbPZZHJ8+Ntgf3f+NGrK8LyQN78F1DjGou7vM41FAW86VGZpAcHdUuoKHpvmvpQcZHbg+WqOEScT7wPCvOlff
 DW7M4KaG
 EGqQqITWgfOXPF2TCaAe78qv26ut+JxZ9Fb3CAwV2AhAOCt5WLII2T3y2vifOaL7lpijPhX63EBV3+m1RxENFy1PDom3vWrx0nedz+YeRs1c/oXvPzmxxPO0IJ/FOcbQl7Udpp3xdl2f7HF/t2OXELehTW28iuv0UUZOIEH88XLUBq2+F0j1Yp6FOGMoF16sAUrT79m3bamqvakNdLUoFED3krPqZQ16Y3VEV7/wcqNYOT0VKSWKEq45D23Bf0uuDe1SZ9lbQw6yPEmcTGklMCD/LEZo36AgxlJ/manbBncWqULW6qQAeX3Oq3y8kIMVJB0FRkKqyzCVX21kWi/RBOnWDeclYxwJR3QUlhhv0JyP/CpfhlCf4bcvqkigW24KPJzXzJ8/C+EnapJJRIoXsnDkNaxyTlsjC/baC/HXG2j7WksN8D7qyeVGreyWRccouJ2DJ6nhODctvLEtypKmNiajNjSU+66qCo9+fGpfOlSUZh8SNX3T3kiWooHrJqloaTBGtiFOC5Vwh9dkd6jQzeRvJ27jRVmHHu3h+hWAyiZOpWhpekoFHOxP9sb6bJ1zQ+qWrwgBXFldRMjz58RQ00aW/b7AH/qXitTpB9f7vLpHE0CK8jmIzAHsy5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Dec 2025 at 21:29, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Ankit Agrawal:
>       vfio/nvgrace-gpu: register device memory for poison handling

So I had to look at this one because there was a conflict ("int ret"
had been removed by another commit), and after looking at it I ended
up deciding to revert this patch entirely.

I may be wrong, but that patch looks *COMPETELY* broken.

It did

  nvgrace_gpu_mmap() ->
    nvgrace_gpu_vfio_pci_register_pfn_range() ->
      register_pfn_address_space()

using &nvdev->resmem/usemem, and honestly, that looks mis-designed
from beginning to end.

If somebody maps the same BAR of that device twice, the second call to
nvgrace_gpu_vfio_pci_register_pfn_range() will randomly overwrite a
node (that "region->pfn_address_space.node") that has already been
registered and inserted into the pfn_space_itree interval tree.

You can't *do* things like this!

Maybe I'm  misreading this, and somebody should correct me, but it
really looks like completely broken code to me. It basically seems to
assume that those two bar regions are mapped exactly once, and I don't
see why that would ever be true except by pure accident because you
only have one user.

That may be a common case, but that doesn't make any of this correct.

Again - maybe I'm missing something. If so, that commit can be re-done
with explanations of why it's all correct.

           Linus

