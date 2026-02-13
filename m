Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A743EEA86E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 00:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E2A6B0005; Thu, 12 Feb 2026 19:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C4C6B0089; Thu, 12 Feb 2026 19:24:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2E16B008A; Thu, 12 Feb 2026 19:24:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6D16B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:24:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C6841B3E87
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:24:04 +0000 (UTC)
X-FDA: 84437536008.01.222F5A6
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9462C18000C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:24:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J7aZHOJI;
	spf=pass (imf16.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770942242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiWkmmxe6Dtv6DaT+4Dwz6iXmfyPwWvAg9n0EYhaj1A=;
	b=IRmuKLeFK7Tuw9WcOXPBLjoDzp2C3kUDySG2YbZ/TGNBVCHx3IPP346+Ta1Vo2pghXvefv
	AKJ1rxQtCmrYnSw9rLgVhqjSKaL3FYJeTd23JgMAbCBs4NHjrcNaPnet9UWiqWl8NI5f6v
	umdkN07e5uen2g5Vmk66oTlkwB460O4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J7aZHOJI;
	spf=pass (imf16.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770942242; a=rsa-sha256;
	cv=pass;
	b=C4B7A6WO6qLpnGOnqf6plJ7yeaTNFT8Unp2BztWuy1vDNwnn817/MhJJmwXZ7tZujXzglv
	pN1sEZYJIpnHWlPdG06AD6B+vfUyBe3QFxglaUDX+R6uXdkCUkqTVyferUGfotvNeI09s/
	DMj3Smsq/845w8l6kraf7hIE+qJxGWk=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65a26c220b6so492213a12.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:24:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770942241; cv=none;
        d=google.com; s=arc-20240605;
        b=H4U4WbjC24uGOt3ZFJ17ZJtXTB3XDbY44XVIaI7vlX6ab7YCjTnlDG9w18m3Doso6g
         /Zv6r2TDDzLfbUzjSUqaoLZ2zmjZsYJDSlctRjfE3rAmaveRBMLZx8WpHRjdLca8TMhp
         6PGG3fHlt15e5UbHY2IaEP+IcOH1cXLyEx9cNoSYBl00luxURqMTQW69L86gAodTkCAq
         8Xo9V+oJdA4P6NK1CckLn5tqslPvgxp24nEigHtIzixciFVcV1p9JNkOrJV/NspDTgtx
         t+8XQymEtGAj5NDnT3LeOLett4qSe2doFHDxg71Xu/bQphdVyEuPjva0+84on4qIc7Di
         KxXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KiWkmmxe6Dtv6DaT+4Dwz6iXmfyPwWvAg9n0EYhaj1A=;
        fh=AvOIkmad3HkmrqVTV/2aO+kZs7FYFUzMriCYAejtQU4=;
        b=byQzV1dG0tmaYi79vaYnW3OOHjlxGDIXViqXFxG96wmjzC9qJJ99DCdo2bbX9TwZZ1
         lhSyWWkBe2HYvV69g5GnKmAovbLGGH0w6/XX9NOMPwvahYDtzLNJxzLWCCBFC9ph0dPd
         Nii6NTm5RyX+OVclIS2JgeZNesUbwKN8hWMIfrSf7AmNMb85SW88IaVrx2C5ymdzIDfS
         3pXNrdOYGJi9hnuHkCq2/P1MXZ3ZKRh5eEDpwzkJWL50HoLay6viW5bLLnI2aCqX37T9
         /SQ/8rffq510y4D7G2bXqC2QfSN8up5XfzLQnzGLo4pKoUUAj1IVke6HuLa/PjQ/OsiJ
         LD4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770942241; x=1771547041; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KiWkmmxe6Dtv6DaT+4Dwz6iXmfyPwWvAg9n0EYhaj1A=;
        b=J7aZHOJI0AXNy5829UpSJIfNFOpfayqgajBDppEknI7L0h5UWGz0kHV/pOd/vhdELs
         4kwlqEcrGEZyrZWuJRjzU44vI72nVK+h5Y/KOx9hS0rFkFNhWThOeH7zALGMfIeoALHX
         LD2KSW//Yk6+SulFCZHo9LxqcCCvv2M5a78cmio2s0fUBz802oRqr+/kuxPgzQlFFhk8
         3JEaknL5altJ+QYPjvz9IO8lwlCKRp38sRdzLwUbmbkG0AS0yAUzq+SOxZ6RlLTBbzLv
         0XfGzbaMU+5FggEoohavkEr7eeOQWbJZYtlmGkslGUyCoPTI6XkZRAOhnefFkLtM5qM3
         9JhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770942241; x=1771547041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KiWkmmxe6Dtv6DaT+4Dwz6iXmfyPwWvAg9n0EYhaj1A=;
        b=WOBvN/q/lF+d8szup8ghZGzC7nBODn1TXX9aq+oLdWfoD7ss0YFIkTOAmntsqebdmk
         5QRgUZQ5/YwcB/xmzTRV6EB0Md2gwsmRJ+7WyhbffiKDTBTrSv51lsNoVX1hYL1wD+RI
         C7OpY33f2rq1ETjtmPsGPh3oPwY66jWj+/wnzWo7Zj5X/mrGsTlQRtnLzQG3scl71+r9
         jCaoU9yJBMcxjKeuNvlPX3Tpzb5d66h3hcT4mB4JLBonVVi77g9KyqyzI9FPh5jIV3fl
         QQp0CxVJt+EmZbZ5bewldpw6fCR1qi07gGwXCxK5tq7awcPi9YGUuaOkgKserFGxt4lW
         7kew==
X-Forwarded-Encrypted: i=1; AJvYcCXpPIR/rs38vNMmugL1kTEaf8AHj07s31eqSBMKliDUsUQRobhug3LPyZWf5Cv86T+ZfJ7KUJapqQ==@kvack.org
X-Gm-Message-State: AOJu0YyBkpofAT/7j8nA9mEjUUPk/ZV0Ji6WlQQpvIp+/pKkrl+xzuXY
	Q2Vn3MdR0mhJEqYqAZYEKFIv/W0e6Ivj1StsmmyQRBXbPWdlq2Q4vsUr9ocdjprLmu1FO/Len+b
	MvhmZpjqiVeVYXqj4Y2nU3ARVgjZLpHw=
X-Gm-Gg: AZuq6aIi20Sp/7y8BSEtmytqvex3daW+NQV9o4d6Tq8ZlB4NwQ8Q8iDVl9q8C7Vfoc0
	jNSxZ6CcBEUHiSooySS8rDzB/dnFGO6xf0Zy/5rXL3p+CeQTWN9bkXAQowxCmZMOeS3Gn7J7Aka
	4g3ldBrZ4JZp7fzVRZhXeJLpYIBVxQFP/lRNvJNw7CAdlkdv/85ph7o+nH1AxlnHwTI1bCPQuft
	zIcg1xLKtVh81qoDaYbfWGwBRf9lLtYnDZqXgzTTFewTX3gWaoiRI8hHsRsZ8LzSMojvypAQoPf
	jtQEHguw/A==
X-Received: by 2002:a05:6402:f0c:b0:65a:cdfb:58a7 with SMTP id
 4fb4d7f45d1cf-65bb1150e75mr12391a12.9.1770942240661; Thu, 12 Feb 2026
 16:24:00 -0800 (PST)
MIME-Version: 1.0
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org> <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
 <aY4Ty6G6A3478_JS@arm.com> <aY4fQOgyx3meku3b@arm.com>
In-Reply-To: <aY4fQOgyx3meku3b@arm.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 12 Feb 2026 16:23:49 -0800
X-Gm-Features: AZwV_QgfHXa9n0EwxBN17jYlIXlYkW9K72BfMpLSkyoaJrioE46k6v6Cic8y7Xg
Message-ID: <CAHbLzkoZVvt+VOV4kcAFdmpNC3gmhOd75Y-qizHirNnD=9SW5Q@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tejun Heo <tj@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	Linux MM <linux-mm@kvack.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org, urezki@gmail.com, 
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: m3tpkzgocpwpmqc55kfpfueh6mmjp88b
X-Rspam-User: 
X-Rspamd-Queue-Id: 9462C18000C
X-HE-Tag: 1770942242-461213
X-HE-Meta: U2FsdGVkX1/wZQbO83OMVvu0Z3D35o+iAUxHFPia1+Ay21jpPBiA66lpTWUKQm/KTgH7L/6fgGi8LepCBwELTIeoMn9LjBYyNUYjjT9Jy1BHDSaQDtXetECv1rzR495EkktgTkK1PViVspoc6dHxarULdFDPp8JHgsw9TNldNchmYh1CGI1iXVmmAWO8AyYScUuXGTAve/FCiVTt1Gmg78agW6a/K3gWmvda7Gw8pEmgYkeP4xrcHjUO6Fcx4x2VAJyIcYHFbQbwoAZjs6096b3dndSX5E3+u7S7Jr/GjDorj1741+L21NmSEvAOgQZqNqHgmbwnQ0idFW/IUU19gMZ6Vgo0AcKVKqYIw0YwMY6oPOfbNVuRl51A+yD9xEPRJAWv3uzWu2BgV2ziTdptoDVBPGD6Yoho5r9iBNpoUUuW7JPCjOGBH4eFJuSlsyFhuLS93facIivfYDDR/ribcmRRqpqT/14yNQh5uGO7r43P3inwSPzTqG22GjkK8U6L6X+fyFpgqW5xoqbDtuvszViLdcF3jH4IqPFji0pbhAsgu4mCKIRa2EcWq8Z3D1JZvylB27pRw822XzgAVZ6mr5izCXfK3NnaEYA6HtMCTdFwE91uY/C+/M9zD7dTUnzkBW0iVDSlo2Df6fwjlpm6xFtdmKs1252nIu2fTB9xqLDiBmKNbzkvHre0Iv1GzH2J9Pv2cpC97PAM/caAiUX2r/B6gFZLp28BjP1oDSzPGx3HaphBfA+29ZYfDYGdBQFZdc84CbFmZcqWVcWzWhq5eceY7c07Cl/0zr3W2D27qA6q3V/zP+Y6TvEuxJNFTRy2/O74CFXXZlqYpS2oSbqIp15thqG7KTsKHwyyu/v38AXCEYwEYfu4qoA4Ksr4+NN9Lt6tUz/BmV11fArL2JTG2C2qUiqhtLsj51Rng65DPg7W+mo3u687xFtw3aMmT3itCx7ljf25/DnSpBQpRdd
 DNWRd9pK
 GVx9orIOae4db07waYv9pb+1eIqCapsckQe3kmXnOvYPUUs+tehhFyhVNHeEO84qkcQDK5n/BkewKJSCvAYQ3WtqFOyPbMxI7C5ECFlbUGHLHMHDSxsszT0MgqGSlCuNH5okpf4Gts82JIOOAGGxB7VjWEl49lR3PHvYMnAWyMPvIkZf53g1RRCnZTOgfqLm8IwfExqxMYujYG9uRlzx456LpC3++qXHPYEBTzWMNi/IcNtxiNNmVqltzImf39fJWDTNGQ0zVi1LUdAvvFqNd4AQp9NEDnIB51Gl/PNJy3O0bMcJ4sdDIqpjvzhHEJoiokWvGhYgS/hBoN8i1PNg72kiH+CnGkH+L6wRf71+D/F7t356LESnCwhDLSdAANL4MdYTnDB/fsnR7orEgJB4C533eYXz9H7GZOI2Qcp23IxE32kJfwfT5H57+PfCyBy2Xz4FcvpNvx91cdI2aBgFCYIerB2EVV+FAZ48961MDnMjaQXlPzffGAn4WTw9vUHrhsUGq0tDx1ZFrY13M73KIYL5vo3hntCIxGa15
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 10:43=E2=80=AFAM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> More thoughts...
>
> On Thu, Feb 12, 2026 at 05:54:19PM +0000, Catalin Marinas wrote:
> > On Wed, Feb 11, 2026 at 03:58:50PM -0800, Yang Shi wrote:
> > > So we just use the local address for this_cpu_add/sub/inc/dec and so
> > > on, which just manipulate a scalar counter.
> >
> > I wonder how much overhead is caused by calling into the scheduler on
> > preempt_enable(). It would be good to get some numbers for something
> > like the patch below
>
> In case it wasn't obvious, the patch messes up the scheduling, so I
> don't propose it as such, only to get some idea of where the bottleneck
> is. Maybe it could be made to work with some need_resched() checks.

Yeah, I was wondering whether it would make something wrong or not
because I noticed the comment right before _pcp_protect().

And I saw some confusing results by running kernel build workload with
the suggested patch, it should be caused by the messed up scheduler. I
can got much more stable result with "page_fault3_processes -s 20 -t
1" from will-it-scale. The test just launches one process, so it can
minimize the impact from messed up scheduler. The baseline is mainline
kernel.

systime improvement:
baseline           no schedule              no preemption
1                         0.96                             0.92

profiling diff (perf diff)
baseline vs no schedule
5.48%     -1.40%  [kernel.kallsyms]      [k] mod_memcg_lruvec_state

baseline vs no preemption
5.48%     -2.21%  [kernel.kallsyms]                   [k] mod_memcg_lruvec_=
state

>
> > (also removing the preempt disabling for
> > this_cpu_read() as I don't think it matters - a thread cannot
> > distinguish whether it was preempted between TPIDR read and variable
> > read or immediately after the variable read; we can't do this for write=
s
> > as other threads may notice unexpected updates).
>
> There's a theoretical case where even this_cpu_read() needs preemption
> disabling, e.g.:
>
> thread0:
>         preempt_disable();
>         this_cpu_write(var, unique_val);
>         // check that no-one has seen unique_value;
>         this_cpu_write(var, other_val);
>         preempt_enable();
>
> thread1:
>         this_cpu_read(var);
>
> thread1 is not supposed to see the unique_val but it would if it was
> preempted in the middle of the per-cpu op and migrated to another CPU.

I'm not sure whether kernel may make some decision by using the
counter read from this_cpu_read() or not. If kernel does so, it may
mess up something if the wrong counter is read.

Thanks,
Yang

>
> > Another wild hack could be to read the kernel instruction at
> > (current_pt_regs()->pc - 4) in arch_irqentry_exit_need_resched() and
> > return false if it's a read from TPIDR_EL1/2, together with removing th=
e
> > preempt disabling.
>
> This one also breaks the kernel scheduling just like using
> preempt_enable_no_resched(). It might be possible but in combination
> with additional need_resched() checks.
>
> --
> Catalin

