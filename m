Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176A2CD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784538E0019; Thu, 13 Nov 2025 15:00:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734C58E0003; Thu, 13 Nov 2025 15:00:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6233D8E0019; Thu, 13 Nov 2025 15:00:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51EDE8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:00:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F120D1A013C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:00:10 +0000 (UTC)
X-FDA: 84106650180.21.81117A9
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id BD4E110000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:00:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g300EMOg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763064009; a=rsa-sha256;
	cv=none;
	b=GnGF/RQKrV0FP4roIQHVlNzVX6AAKYYLwB1x0T26BuBUefIILOp/eelK4YLZvQ5Z21BhYU
	EFwDX+4I21+pdY5cNAm8getz/bvn48jZrc41TPclrHJzs2uj000W/+vUNeVFfDw3zddhCl
	ms57XsmS9IZasRbKbG052RAWwjEeE5I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g300EMOg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763064009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8UPfICDEEgZp4uB+X0RyA3ytCQQbxJjsb+km2/EZ0I=;
	b=VTKY4k8LK54j0Q95hgVB0sn1BeMolbvNFljWuUplQZRKMFseA9H2Lp2ssUcx/hO6PFufBX
	Fv9DkJDhCTJ3cDULoNcnmaqdXufa9ht2svZSwOMyETwLqcuwA6C+/GNX2mjoF0OwUKjvSV
	N40ox2ZFAvBBt0KZZXCxcGfFdMwDrvY=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so2252942a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763064007; x=1763668807; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8UPfICDEEgZp4uB+X0RyA3ytCQQbxJjsb+km2/EZ0I=;
        b=g300EMOgnbyNtJ1LIqWv6bWGFnIzNep9ytwu+IDHiKC/mMsOdrxhg0nU61qq9SKyc7
         rn/ADm6tsp1i+0K3lITLg8CUOtdWYTwDznpHCyLKO1zpozLwfoSzdpjA8JWZ6B19gzIL
         3BFYO8tmcdXFSARay14r4jRGpA3iCtrbkFOBBekMX+oBLkhDKPID55WxLSjeUJbWC5kl
         2DKdTfeIzupwk+iwLjgox6oL2j0G7dcgvgwHlt+pvHvNCr/n5ycETCBbVntJ/AX0a7MJ
         FqGXD2q1G+4YvfRpSClxGa99s1liRzhfw9BnhVOp087Ql5cR8Cy/jcsfmWNDIZk/NoG6
         s9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763064007; x=1763668807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y8UPfICDEEgZp4uB+X0RyA3ytCQQbxJjsb+km2/EZ0I=;
        b=JAXCRG1E/RmdSwBEPHFuF7QMKQm3vLd3ykG/qsYYsZs6hBR/Cf+qDRe1jPZwYWDskI
         F56hvol0/yHvSB3Qdm1Q9Q8p6bHxnEb/l0USg1QKvI12I+2/1QDCTlCrIRcUf2C+Ye+e
         a2d0PUJG+BxiaOIeXbIVcNrwbCFjXK/Npkj60W/50CVoL56W5yKkDa4hF5ujqtQI9+Eh
         zqcODdY2TobGgC9Opb3w4jUv07JmG7w8HQ6AtnpgmoUg4E8l3YIuMpl+BNcxfwgD9h2X
         V5MdQszNx4w1Ik5ovywbmqyE+WpMiyN2fylaA/jiMPgAE3dxwgNZ8ODEMaDzf2xs7TLF
         M+Mw==
X-Forwarded-Encrypted: i=1; AJvYcCWqiffKlb9GyGRo6q3C8y8qlEhiecTVKf5JsUQv0QNzL50j9q2Ww/VG4Q9jNY65pQQdkXzbi3gDgQ==@kvack.org
X-Gm-Message-State: AOJu0Yzki+qilI1e7sLy1MPklEk+8AunOHdTLohCBKGEE/n/tJv3+82V
	ZWP/UXaqyt+giN5XIMqKuCKCnBfDuKuW5OVUGhJDpO6kiIhUOGHMI0B6LP7FHahG9fAVZzHbKJg
	owJtQ9SpZ9HmYeOmie61aJ7OGlUeNhJmTcpQy/lcIuQ==
X-Gm-Gg: ASbGncvJbkKotduq8lpTQUMHvauFNYZuXGQrQYzytbXPk5izGy4hQUH2UxwdIfj20d1
	Hn4hTgucLps1OD88ZNBozk8z/GjC3NaGw0I/Gzf27oVLPSDXRXaQsV2npcUvDj08IGxB66z6Gr7
	XJ4HH5VuMEiYn6d8s6d3FFQHR/Hr2n3aflBFPYLBSleom+0HXeAIjINqf+6NBCuaAMm5flx70uK
	l8YvZHNi6fAaW8944i9B9QDPMAwn9xogrdU4iM6j9rcEp0fU39y55wHNg==
X-Google-Smtp-Source: AGHT+IGtgb5lqtXrRSejuSHsDHqiIlxt1wqIGMSt45RvvTjAlTo2PtIgEUYmRcunbv8MILvS8OFEKnjDlBfvJk22ITE=
X-Received: by 2002:a05:6402:144d:b0:63c:533f:4b25 with SMTP id
 4fb4d7f45d1cf-64350e2091cmr477401a12.15.1763064006737; Thu, 13 Nov 2025
 12:00:06 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev> <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
 <442fa82e-16ef-4bde-84eb-743450222468@linux.dev> <mafs0qzu69gei.fsf@kernel.org>
 <CA+CK2bBEe16x0em1gRxQD3jhfV9t3QA2vx5ifk2pKb_WEoMTeg@mail.gmail.com>
 <0735e1ef-2b65-4a54-b4d5-964fb875cd09@linux.dev> <CA+CK2bBnnGyQ-N8-XS3W3tnSRwvFbstOdo0oDSdkF70KP1AVxw@mail.gmail.com>
 <475ed48d-1f62-4983-94a1-64e41c463c36@linux.dev> <a1aa7736-d014-477f-a516-2281a70fc8c1@linux.dev>
In-Reply-To: <a1aa7736-d014-477f-a516-2281a70fc8c1@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 14:59:29 -0500
X-Gm-Features: AWmQ_bnRlxMOTpjJYa9c1wkJd45YYnIOQytdlbCIfP7YmJM_Ee4y6ZWF-j5IBYQ
Message-ID: <CA+CK2bCwqCHr6oecmL6R65qjgXZNuzU7SJ9diVkYX442tUdU+Q@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD4E110000F
X-Stat-Signature: yftcky1tqb884d83jk6jo83t674e9zh9
X-HE-Tag: 1763064008-578286
X-HE-Meta: U2FsdGVkX19Psca21spy2cLGgob7ulqLy+Xcs0kcZC3QL2tXkz9oh425CNZGMeHC1cnKhB2Z+hv0bXux43h6sawHnXAlzzCR+l4W10KOn51upezEZWlbuYXBtIfq3dD8o8+QgRaihvTtNIi8VGKTO/l8vIcuuglhddBvhxyM7pKJd9/I6Q6EMi+M6lsE+KWjC1K4XSWPapT51RU7nW0kr5AOIXegMwIQunIodtWx3JQj6Jsq5WpSpy0E0ibMibJR8dYbOJSvsqgRO0xj/rX8+Wxd05vnBO3jbo91LrwQFaqm2WngamQM7P8ZYBPts5zi6XHaYZrPp4iFB/1IPuh2znWt9BmupBoMk7Z2jmLH/pV1zUNRyOOfXz3LCDYvrCBF9IXTilNaXj57IoOZVPKO22rIJYpF154H7IdLcpVEl4Jn++R6rWFmxYEd/vzbnnEtrf/9oS+wV3voTC5d5k2mC9tMGr/pfW5YuYcVfTI1cbywg6D1vFURkmBI13YriviQUKgaIutGYyQZoHqy47xKtP+D29SSXhkB/aeZzrpPhPs16zK+29OJlhdMdH/n5eiKalHwYvf719c9HA3BZQFgaANHteIGWLgDvKtkTkkWXpcnm3AU7I1Zpi0TbqddJMJV3bYqzJpaS9NgpvP4B7OBjZz0kUA/2E44A3JuOUlE99McQGyYo7nFF4I9NX9SvilBwtLvmHhsdZhIApFNHTUiOsrGLJQ+E5UQ3spDWBJyuFJAyd8Htm+K8HwjQgI46BqX9qDkNHGnW7RpoMcjowSU4ZUZmOgeFKzy1k3Z+MSkkTxWSFUfUhHaoUoLzqz0DUuS3dXZ/hBswLm3cxTli5tDyjQJB2CGnKyIHX4usmyR8uYfLjEZKBsuVCAOst3S5uSCw5O6RRzQwQnzx7v25Ti7lq+yIWxjnC5I31a7vdpaaABGiKvGeKSQY3ayWEKOSbO9cEZ1TwR84i42gBCfpMK
 Go7lgQyO
 0KZbJWN64OqYKeoN1XAuuv3DDCh3Sl/QfE0c8PnAZnWI2D3PEiTkwws7mCrWXY362AKOf4rbfH5LF2Dw4R/Wz9kbRR2uao32uAAiwdij8HIdEm93YRGD+EinTVMuoLqMYka5kquRt2rdGF9iwithgNtDocZlnfdKAGZocgMDqyQdrsK/eX9/HOedLRkFXgtaPZ1J3W/XpI8iKsjGAubJfQhligpuTKumE/5tJZFNBgyav8QKBbfH3Jol1f1mBGb7NHaU09Dv/gegRVYUS3ou9sLZo2YCqt/LbqxlmjbE5yr+avg4jX94kRCQFAaFBjTnUnsX75P1Z/EPCIpv9jnftL8Hnkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 9:11=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> w=
rote:
>
>
> On 11/12/25 5:41 PM, Yanjun.Zhu wrote:
> >
> > On 11/11/25 7:26 AM, Pasha Tatashin wrote:
> >> On Mon, Nov 10, 2025 at 11:11=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.=
dev>
> >> wrote:
> >>> In FC42, when I run "./luo_multi_session"
> >>>
> >>> # ./luo_multi_session
> >>> # [STAGE 1] Starting pre-kexec setup for multi-session test...
> >>> # [STAGE 1] Creating state file for next stage (2)...
> >>> # [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
> >>> 'multi-test-empty-2'...
> >>> # [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
> >>> # [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
> >>> # [STAGE 1] Executing kexec...
> >>>
> >>> Then the system hang. And via virt-viewer, a calltrace will appear.
> >> Looks like mountroot fails, are you passing the same kernel parameters
> >> as the during cold boot?
> >> i.e. kexec -l -s --reuse-cmdline --initrd=3D[initramfs] [kernel]
> >
> >
> > Thanks a lot. It can work now.  The logs are as below:
> >
> > "
> >
> > # [STAGE 2] Starting post-kexec verification...
> > # [STAGE 2] Retrieving all sessions...
> > # [STAGE 2] Verifying contents of session 'multi-test-files-1'...
> > # [STAGE 2] Verifying contents of session 'multi-test-files-2'...
> > # [STAGE 2] Test data verified successfully.
> > # [STAGE 2] Finalizing all test sessions...
> > # [STAGE 2] Finalizing state session...
> > #
> > --- MULTI-SESSION KEXEC TEST PASSED ---
> > "
> >
> > Yanjun.Zhu
>
>
> Hi, Pasha
>
> In my tests, I found that luo_kexec_simple and luo_multi_session
> currently depend on the glibc-static library.
> If this library is not installed, build errors occur.
> By making the following changes, luo_kexec_simple and luo_multi_session
> would no longer depend on glibc-static, reducing external library
> dependencies.
> I am not sure whether you agree with these proposed changes.
>
> diff --git a/tools/testing/selftests/liveupdate/Makefile
> b/tools/testing/selftests/liveupdate/Makefile
> index 6ee6efeec62d..b226b9976150 100644
> --- a/tools/testing/selftests/liveupdate/Makefile
> +++ b/tools/testing/selftests/liveupdate/Makefile
> @@ -3,7 +3,6 @@
>   KHDR_INCLUDES ?=3D -I../../../../usr/include
>   CFLAGS +=3D -Wall -O2 -Wno-unused-function
>   CFLAGS +=3D $(KHDR_INCLUDES)
> -LDFLAGS +=3D -static

Hi Yanjun,

Thank you for testing. I prefer to keep the '-static' flag because
these self-test files are not executed in the same environment where
they are compiled but in a VM which might have a different userspace.

Thank you,
Pasha

>   OUTPUT ?=3D .
>
>   # --- Test Configuration (Edit this section when adding new tests) ---
>
> Yanjun.Zhu
>
> >
> >
> >>
> >> Pasha
> >>
> >>> The call trace is in the attachment.
> >>>
> >>> Yanjun.Zhu
> >>>
> >>> =E5=9C=A8 2025/11/10 7:26, Pasha Tatashin =E5=86=99=E9=81=93:
> >>>> On Mon, Nov 10, 2025 at 8:16=E2=80=AFAM Pratyush Yadav
> >>>> <pratyush@kernel.org> wrote:
> >>>>> On Sun, Nov 09 2025, Zhu Yanjun wrote:
> >>>>>
> >>>>>> =E5=9C=A8 2025/11/8 10:13, Pasha Tatashin =E5=86=99=E9=81=93:
> >>>>>>> On Fri, Nov 7, 2025 at 6:36=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@lin=
ux.dev>
> >>>>>>> wrote:
> >>>>>>>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
> >>>>>>>>> On Fri, Nov 7, 2025 at 7:00=E2=80=AFAM Pasha Tatashin
> >>>>>>>>> <pasha.tatashin@soleen.com> wrote:
> >>>>>>>>>>> Hi, Pasha
> >>>>>>>>>>>
> >>>>>>>>>>> In our previous discussion, we talked about counting the
> >>>>>>>>>>> number of times
> >>>>>>>>>>> the kernel is rebooted via kexec. At that time, you
> >>>>>>>>>>> suggested adding a
> >>>>>>>>>>> variable in debugfs to keep track of this count.
> >>>>>>>>>>> However, since debugfs is now optional, where would be an
> >>>>>>>>>>> appropriate
> >>>>>>>>>>> place to store this variable?
> >>>>>>>>>> It is an optional config and can still be enabled if the live
> >>>>>>>>>> update
> >>>>>>>>>> reboot number value needs to be accessed through debugfs.
> >>>>>>>>>> However,
> >>>>>>>>>> given that debugfs does not guarantee a stable interface,
> >>>>>>>>>> tooling
> >>>>>>>>>> should not be built to require these interfaces.
> >>>>>>>>>>
> >>>>>>>>>> In the WIP LUO [1] I have, I pr_info() the live update number
> >>>>>>>>>> during
> >>>>>>>>>> boot and also store it in the incoming LUO FDT tree, which
> >>>>>>>>>> can also be
> >>>>>>>>>> accessed through this optional debugfs interface.
> >>>>>>>>>>
> >>>>>>>>>> The pr_info message appears like this during boot:
> >>>>>>>>>> [    0.000000] luo: Retrieved live update data, liveupdate
> >>>>>>>>>> number: 17
> >>>>>>>>>>
> >>>>>>>>>> Pasha
> >>>>>>>>> Forgot to add link to WIP LUOv5:
> >>>>>>>>> [1] https://github.com/soleen/linux/tree/luo/v5rc04
> >>>>>>>> Thanks a lot. I=E2=80=99ve carefully read this commit:
> >>>>>>>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f1193=
03a1d83f0ff08fa.
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> To be honest, I=E2=80=99d like to run some tests with who/luo,
> >>>>>>>> including the
> >>>>>>>> selftest for kho/luo. Could you please share the steps with me?
> >>>>>>>>
> >>>>>>>> If the testing steps have already been documented somewhere,
> >>>>>>>> could you
> >>>>>>>> please share the link?
> >>>>>>> Currently the test performs in-kernel tests for FLB data, it
> >>>>>>> creates a
> >>>>>>> number of FLB for every registered LUO file-handler, which at the
> >>>>>>> moment is only memfd.
> >>>>>>>
> >>>>>>> It works together with any of the kexec based live update tests. =
In
> >>>>>>> v5, I introduce two tests:
> >>>>>>> luo_kexec_simple
> >>>>>>> luo_multi_session
> >>>>>>>
> >>>>>>> For example, with luo_multi_session:
> >>>>>> Hi, Pasha
> >>>>>>
> >>>>>> I enabled "CONFIG_LIVEUPDATE=3Dy"
> >>>>>>
> >>>>>> # ./luo_multi_session
> >>>>>> 1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module
> >>>>>> loaded?
> >>>>>>
> >>>>>> # ls /dev/liveupdate
> >>>>>> ls: cannot access '/dev/liveupdate': No such file or directory
> >>>>>>
> >>>>>> # grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
> >>>>>> /boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=3Dy
> >>>>>> /boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=3Dy
> >>>>>>
> >>>>>> I made tests on FC42. But /dev/liveupdate is missing.
> >>>>> You need to add liveupdate=3D1 to your kernel cmdline to enable LUO=
 and
> >>>>> get /dev/liveupdate.
> >>>> +1, kernel parameters require: kho=3D1 liveupdate=3D1
> >>>>
> >>>>> Pasha, your LUO series doesn't add the liveupdate parameter to
> >>>>> kernel-parameters.txt. I think it should be done in the next
> >>>>> version to
> >>>>> this parameter is discoverable.
> >>>> Yeah, that is missing, I will update that in a standalone patch, or =
in
> >>>> a next version.
> >>>>
> >>>> Thanks,
> >>>> Pasha
> >>> --
> >>> Best Regards,
> >>> Yanjun.Zhu

