Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB2DC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8AF6B008C; Wed,  9 Sep 2026 14:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39FF06B0092; Wed,  9 Sep 2026 14:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD8D6B0093; Wed,  9 Sep 2026 14:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF626B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:43:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BE9D16030F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:43:51 +0000 (UTC)
X-FDA: 85195097862.22.782F4DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05717180003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:43:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIdiZAtB;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788979430;
	b=Sva1xgJXaeU8W66V0f+GY/aR+NSLQxKr6iDou85HZeK/cBgtE7CekuBQmhoS65Nz/8hR+B
	oWBXkxry61rFDCqfiO1i7aIUDpUKo+Xi9slvI0OWMdRZQt91+PHNuqhCRos39BAQC92cut
	lV6S2Jg5wE4D4GdBHauJyxijRQ8KEuM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIdiZAtB;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788979430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBO086qLSBOOKWmDT9TG7Y9H6Td1it1Mgr5V18SRHdc=;
	b=Sz9xsBfY1/6I2zmIM1fxmWXC7IwF230NvsAYlvJob1qQg9CL/hg5ERDg94v5tQoChWFog1
	RpqNlMYJ2ywPquYLthO/pdHVRfXd68W8k9j214evQ44FfJHeemAvr0AL9ekCpvlF+M3S83
	8ksDrZrvJgnl4oHTJGjgwDPEzslFXPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3374D4143C;
	Wed,  9 Sep 2026 18:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7D51F000FF;
	Wed,  9 Sep 2026 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788979428;
	bh=cBO086qLSBOOKWmDT9TG7Y9H6Td1it1Mgr5V18SRHdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIdiZAtBo2In6rb9LsXbLf3z6fGM/GGY+ucwjosNGwZEyFo7paekLwcwLMZvxRanG
	 PTthba8l7QoWRmJ1XhNegyKr4+BuBnWg3F8PA+E/mDPZ6zL0BEcHTRzLfeaSxDx+nc
	 dSh7Gq6eW7Q0Ph0fZXh16LXjwA+6tnXdYRhFEoq+sFonkP/erJa6/5Oy1sxkAIouI9
	 VzBzZQqqPv4iJ0c8UCphKKHG6grWAZwYgxQUiTiGlnC/ETnDe65nd7g2G4iDTzsDRU
	 RYHmTn4WXHivWkfSq/TTjwkVkFBaE4qTizAxuykJK/GpnqyB3floJER0UjRjl4UpDa
	 nyf/VTRgA6HJQ==
From: Tejun Heo <tj@kernel.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal =?utf-8?q?Koutn=C3=BD?= <mkoutny@suse.com>,
 Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 David Vernet <void@manifault.com>, Eduard Zingerman <eddyz87@gmail.com>,
 Viktor Malik <vmalik@redhat.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 JP Kobryn <inwardvessel@gmail.com>,
 Mykola Lysenko <mykolal@meta.com>, Nathan Chancellor <nathan@kernel.org>,
 kernel-team@meta.com, linux-kselftest@vger.kernel.org,
 cgroups@vger.kernel.org, linux-input@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v4 1/4] selftests: add shared lib.bpf.mk to build BPF
 progs and skeletons
Date: Wed, 09 Sep 2026 08:26:33 -1000
Message-ID: <178897839380.2.8401342105193256410@kernel.org>
In-Reply-To: <20260908235552.2610256-2-ziyang.meme@gmail.com>
References: <20260908235552.2610256-1-ziyang.meme@gmail.com>
 <20260908235552.2610256-2-ziyang.meme@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 05717180003
X-Stat-Signature: fkgpxfzroyhqpserjry71shar36m7k4p
X-HE-Tag: 1788979429-819591
X-HE-Meta: U2FsdGVkX1/Xom4QJOl3vXnJYTFzDIqnuqn8thJPS+vD6BPZku1ZlO2zbq7QsBaE3Dv5r9q26s8O5EDf8KeK6jvrXNPCOPEIOCTpBxFTL1SCrio+Q+X1vyIIe4QRLeRb835WHy14/dYeHUh1JEcgaJ3FZUnOk6kCRP/aQbd1wvI+Y2Ac1j1UYE5BV/2/M5GPoZ5N86JSOnhBd2+NXERctbPU8pAvsK8DwQTu3E2I2my2APZtY6lrovmDUZWwRO717YoFtFcUBi84CDalzqLYqN/Nq6rduxo3WjcTi2K4aZoA+ujZ18UcloLHMSJEHmgeKAMx6aK1o5q0mh+qUF8oGww3G4AXc4k9MuoHw4BXP2gtZum4m9g5Mxk641VMai8IKO1pzN+jLiFcdK03s63LU21+n8hM5xZeIFaD3+/o5Jal6Zho/zmCqNQVTVrF2tmEDctN0QNaZOrDKbNk/2TMB/kIouKNmqDl2tGDt8laUtYxFFwZlZRd+BprLCVEyawrnJ1WHa2pt4rQDYzhEQl30fTyaJPJd4ANIv7Xw/6kfS3q2SizYtSQRIzYLG/TE72p7XxzJaS/Oh9iZUjf4xe9qdBE7KrAwczB6rGGremvo7+XjiSHSPspgiIlWIXwfUD347JpWjAbgk3RV8BBgvgK4k6lYPN8tLf8IGsszopkRnhDcFsO5/V8SiQ15+aDBteOwOAzpW1W2eoXnmWVRr0Ebzrh2lYwh+8JtKEsAyXi/RhQQrlLmJBcNd9TPJ8xDNt18Rf8jLRMIgHKdSOAEjxs0u41pts6E7c1eBm46nzBYaMcCC8pQU+MfAf8FBra95j+DSDq8aYX3BYlRYV36uk64AcZClu0DVv0c0adtl3sh+MdGsXB9TbmZ1QIAybjeIWZ0y623BKOKmN0176uJGi53wPNXmxYqqJrpJTOthQXYIqGXNunR4jSC82O271sX3gKA4xqtz7McJ5DCKj/0YY
 E3y7EiQg
 02R6phoZWv8He+NMxcZoiK7WgTLuBFl56WydzZCtDN3T7Kj2wCh/59BsN7Qm9Gu+dWqkKOLEhe/QvzziKaamrHuHBotQYRowktmt3rV/8CoKi0Y4KnyDs+KADHXmPsVwhwfkTg729/ZxU1xDzCJzXnLH+CbTneVzQbiu7cEzwjQ0M3jz9fpmAOW9D5qQPl2v6ws3LklMeGj5EcuBiVUUpfIAvU/uF2j8MAXBurdpKZXwCk2f45F28WURB/RIq15e7PIz+zNYV+y/FlX0tG+jwOtMYu7YJ+wsmp+9hUQS2CPyeffiyXUeIu/4SZKAPIxoW1hVDxY22QhRTB6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Ziyang.

This is an AI review. The finding below was reproduced with a local BPF
build using the posted lib.bpf.mk.

On Tue, Sep 08, 2026 at 04:55:49PM -0700, Ziyang Men wrote:
> +$(lib_bpf_vmlinux_h): | $(lib_bpf_vmlinux_stamp) ;

Please make the stamp a normal prerequisite, keeping the empty recipe:

    $(lib_bpf_vmlinux_h): $(lib_bpf_vmlinux_stamp) ;

Changing a macro in a supplied VMLINUX_H updated vmlinux.h, but the same
build left the BPF object and skeleton unchanged. Disassembly still showed
the old constant. With the normal prerequisite, both rebuilt in one
invocation. Touching the input without changing its contents did not rebuild
either.

Thanks.

-- 
tejun

