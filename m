Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63DED116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294C06B002C; Fri, 28 Nov 2025 02:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B6F6B002E; Fri, 28 Nov 2025 02:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7FC6B002F; Fri, 28 Nov 2025 02:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 099886B002C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:57:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D84F16042D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:57:03 +0000 (UTC)
X-FDA: 84159259926.15.5AB0580
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id B744918000F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:57:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kjLhSCzd;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764316621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=KO6CFhqSDZYbm0mOxnDmhYJI/5PlvV1unoGfvV0BWDI=;
	b=wt+W4lSYfm4e2tmhYrCNPwALYigoY9w6ye63WWOd1ZoKyz7MWML99lLM8oCEmPATuwxOKQ
	lMzP1QuQjRAhjpcdCSfNOBbhlNRftL/5huMR+Re9uab7TXiNDAHEFuGewn9hk8IjicJ4tl
	WqtZ9UxzqxsQl3xAN2Rav4CAAyBVeos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764316621; a=rsa-sha256;
	cv=none;
	b=P14Vpas6gHFquqsn5tJnXwqzk69VLZLkhsvxs+0JcbwxrZ0jf00inB6o+Mi5VWUps0Eokc
	kwX2DHCj4KzXP+DRbP6a8BPw/h3cjyEaaZ5uR2xEAW4pIHys5gftg5R+d5XDHSowB1N0p4
	1ktwKe55trJ4t/io+w9BVqqWlnw1WMI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kjLhSCzd;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so1858677b3a.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764316620; x=1764921420; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KO6CFhqSDZYbm0mOxnDmhYJI/5PlvV1unoGfvV0BWDI=;
        b=kjLhSCzdTfuYrPCws/0auHoTu15PhFn8K5cAISQazQ1Q8sB+kVLaW3KWO9sNTaiuR5
         C5/dpT2/smo02A8/6SzM9s2RPpJkaBNSex+HdeGKtKqFJulh5nXMnSMTOl+uWCi60PHb
         nlPAtzQYOaKkik3WFU8/ttu3sT3mmDyGSNQxWGF9V14CAwmRy+95QheBjFNcRD5HiVJP
         hANNKMsO0SVYM0jWlOuEhgAeuecQnHn4wwvHKmrryzTSKUUXaa5b1Ovp8QWT6kUTIVIX
         XqUUw9J6glZ4uUAtNPQ/aY5Hy2gEhi12kQ3IsPVTAAxIQBk+I4nAObdm3gE1gqG+7Xod
         Nf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764316620; x=1764921420;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KO6CFhqSDZYbm0mOxnDmhYJI/5PlvV1unoGfvV0BWDI=;
        b=ZT9m/IifmPV32OVAcC1GKigoW/GMWSnV9FpGKoEw3O7ZBQ4gomRW3cVtqw7RPEgFXO
         V9BdYCiKmUTpI/1SIQpMj/43BbpDR5UfaeUYHKCG/QkG09BFbP9+zXa7+1dS1cX67AZF
         zFnyPjPwKhyu8VdVqO/lVrQmLw0so2mPaTrWoU1tYbRUfE3qzJe084I938RKSkUmYRXM
         9TiyJftWcHpHUXo6+oYlgknvr5sBmyfiZN9A7LKvllL0u9rjag+5vPacL4+haRxtfUTj
         oZaYzjB13ODGCAPTu00HGxCmVnVWtYXzCrbnCzrtOS61RG4BKW425zSVdkpb48EnfBDh
         ZmjA==
X-Gm-Message-State: AOJu0YzjvzaYtsqfRm26suKhhjGW1fKYTLsBsFi2Q7sS62zt4rbCP6nk
	3i9pQBRT9kvscXxeFDRW62ZmxYrFlQ39e4W2PdLmpTYJocUEK1wtch/l
X-Gm-Gg: ASbGncvFw6Ymmx2RJz43OHiWUjK1kNQID93peTgblY4+Lnn6YDp+TZdeF17fFgUE78I
	H2K0Tni9sOamQkG82eZrrYnDorqLEdzkhQu1hEuBYHDFKholJLveGCtMqWo5v2fMZ81UC5JOHGg
	TyVRhWrLU70hPzv3YTJIuHAna7WxWFvxAHLh7XK3SvYJqgXESQyw3+u4AZWKku9++fNa4suyMG2
	ISMXuYxAZNfYUMlYDGMgfPqt9AtDU60m8mizikVt7NmGkY8bQGfRcBZh6wrj1RtaMemOMCwUP7k
	7vOKKSDqDcnmqkrq9/8t//wc5MI0ZRTyNDRy2KRRGdasVF7nZmjf7WalEC411lka6sJpxQV+Cvh
	DdA7J3IZlRtmKPebhowG6eQr6WsuJK9OUrqzj/KOq3sMzU8up8GcUkyQ/BAhEO+0GLU+YmJNVuQ
	p7Ot2HHg==
X-Google-Smtp-Source: AGHT+IHuBDpZnopt8Cote8/VIf8qhi3UMfNXGn7GjA6YRt1a3Gw7FVTgXD7eArdg/MnJmDNzssBNYA==
X-Received: by 2002:a05:6a20:7f86:b0:35e:1a80:464 with SMTP id adf61e73a8af0-3614ed95c93mr29015651637.46.1764316620308;
        Thu, 27 Nov 2025 23:57:00 -0800 (PST)
Received: from dw-tp ([49.207.234.175])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d151eb5bd9sm4110823b3a.27.2025.11.27.23.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 23:56:59 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
In-Reply-To: <3cc7d401-c77c-4ac8-abb8-c264fbd9aaf0@kernel.org>
Date: Fri, 28 Nov 2025 13:19:08 +0530
Message-ID: <87y0nqmwaz.ritesh.list@gmail.com>
References: <20251021100606.148294-1-david@redhat.com> <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org> <87zf86n3vq.ritesh.list@gmail.com> <3cc7d401-c77c-4ac8-abb8-c264fbd9aaf0@kernel.org>
X-Rspamd-Queue-Id: B744918000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: y1huty5bw8b7kky9shrg6cmsnb4ju9px
X-HE-Tag: 1764316621-659911
X-HE-Meta: U2FsdGVkX18yOVnqOvy0RnQMqXhmXMhpkjP1zOiCpz/1ouKBOe1QCMKJLQrRFEzB0CTmf4A7qcWKiWmef0/2bu4Tq2WXhQ1V7mqYiknlc7uMIGzeEGWHN7A0fj8uRC4N4ooDUtMhqTMwDmakUE9MpXygESLxUN/DuBfGHD01Hybzdo0lu5Q1aTG2Uz/QxR3q8ZEHQiwrTci7RhoRs7OSHUrTaBRnkdWvXt655W/YPjniuASGcQfweeizOa2mjCt3iCJOWV0yUBUOVc7agzSwRhHsYROkfI/HUbtxWQIiH2lY2JkxnUjWGmJgitrfUStcljyour/j5VHCHDFPkSTyyZyQBnu3gkhn5KmdpQXX1DqQQ0XWR4slzXr8r9M3uQ+4M5fr2RVcu3VY11J4yrxVtCdpDSwByuZvGZCImIZD4OGPECX24PNh/YfTeelLJgjgjPpFFm3gUVoE8uu/idpGJAhv7F5lVdBMGFpvhp9mFrk/ASo7apMXPAvs4EvYNXM6RJz+DwuQMmlY1GnQNQiqDTJnPFC1IeJzBkhXJf+p8aN57+6MoLIFPk1LcJGGRUZdW4JA99/rljIjkts348mYzaXG8MgUnOfi74Qc1w1cyqo0WbIsHyiMVzMS8582ResvPkofcCutMupe72WPEizlRNpb2u6+tCGeg6hAoc1AXCfCmwyBeWkbXS2ns/9C/KK/s+nGqoPgqu6LrPKamWvE5Ur3fdL8AOXOxJDRHeqyPAzCDHYpi0x+QY6E3BjOJi+ugBmxDHxIK27WXzwSRB6NxnCEnW6EBis2ypajrca+sGgOrITsc/axeO8xVbCFmdqXCV2aRGj9Rmdvoi1WIU9EAO8es/ykumwkANtAeBA3+K1khXVJeN76qCH7rMLODymp5v92DveTL/UC9H64xPAXlGtbCjIawQ7G8M+c0TPXkyL826oTNrQp1HK7JmTvanLuQZnEiphumtFinCTWyHI
 WxsUbICo
 6RahlwXjLzXlUE7CHqPs6EfpjDT8eBRLnfGVFNhk/3rFG8V+cg7e1KYClZGgCmhRPCt8qpvxDLpGgExFbcNWc8odthUmJ1seidWOdvBgYy1SqpQPMmDpl0lBhzPtMHMvbRe/mk4hj7sMitzerLIZfeDHpSK8H4Of6vxGVhM81Nc0wicsvgQtTuDK3CoAtgWlLqxNiTSmgi/BXDqCEODYjVitpI2YXEZqn/qrxnqspyEizJSm2iFFdXajBKmymybfuSc/AtDXiuOpmn4QkWtCnvVa5UDdBuo1BZTQxVwZ5rZ6eVckCdoQdsR2JhF1+qgTH81MITg8rlLOvHrgkO21HUb7cMzB7jn25gwdbaYflATFsqM/jTcziqrkCAu+xQD8guLLP03q2GDhPhFAUAN51/wLsHQBg7xo9FSEbMLfA8/K6C6tWPjuj//GIHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Red Hat)" <david@kernel.org> writes:

> On 11/28/25 06:05, Ritesh Harjani (IBM) wrote:
>> "David Hildenbrand (Red Hat)" <david@kernel.org> writes:
>> 
>>> On 10/21/25 12:06, David Hildenbrand wrote:
>>>> Two smaller fixes identified while doing a bigger rework.
>>>>
>>>> Compile-tested only as I don't have an easy way to test right now.
>>>>
>>>> I would prefer for these patches to go through the MM tree as I will
>>>> be sending out a bigger version soon that is based on this series --
>>>> I split of the fixes from the other stuff.
>>>>
>>>
>>> Ping,
>>>
>>> I tried to get CMM running again (using the simulation mode I introduced
>>> a while back), but so far my attempts to get a reasonable powernv VM
>>> booted in QEMU failed :(
>>>
>>> (e.g., Fedora qcow2 images use xfs, but the open powernv loader is based
>>> on a 5.10 kernel without some mystical XFS feature ...)
>>>
>> 
>
> Hi Ritesh,
>
>> Sorry, I missed seeing this earlier.
>> 
>> Do you have the link to simulation mode which you are referring above
>> please? So far I didn't find the support of this beyond Linux LPAR
>> (pseries), but maybe I missed it.
>
> When I did a rework of the CMM balloon in 2019, I needed a way to test
> it. So I added
>
> commit b1713975c31ae20ecc40fd00191ee3fa51445d4a
> Author: David Hildenbrand <david@kernel.org>
> Date:   Thu Oct 31 15:29:31 2019 +0100
>
>      powerpc/pseries/cmm: Simulation mode

aah right. I should have looked closely. I was thinking you meant
somewhere in Qemu, so I was only looking there.

>      
>      Let's allow to test the implementation without needing HW support.
>      When "simulate=1" is specified when loading the module, we bypass all
>      HW checks and HW calls. The sysfs file "simulate_loan_target_kb" can
>      be used to simulate HW requests.
>      
>      The simualtion mode can be activated using:
>        modprobe cmm debug=1 simulate=1
>      
>      And the requested loan target can be changed using:
>        echo X > /sys/devices/system/cmm/cmm0/simulate_loan_target_kb
>
>
> I allows for bypassing the absence of FW_FEATURE_CMO.
>

Right. Let me give it a try first with pseries Qemu. Otherwise I have an
access to pseries LPAR too. I can verify it there. 

> Back in the days I was able to test it with a pseries (or was it powernv?)

Agree the name can be a bit confusing. So 
powernv == Power Non-Virtualized that's the baremetal Power box.
pseries == is basically the Linux LPAR on PowerVM. Qemu/KVM also has
support for booting Linux pseries guest.

> machine we had here at RH. So far my attempts failed to test it in a
> similar fashion in QEMU.
>

Let me give it a try and I will update how it goes.

Thanks!
-ritesh

