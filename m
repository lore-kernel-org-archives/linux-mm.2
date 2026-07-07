Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EE0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337E46B00A0; Tue,  7 Jul 2026 08:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F356B00A1; Tue,  7 Jul 2026 08:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE7C6B00A2; Tue,  7 Jul 2026 08:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 010356B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:47:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 917151A03FC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:47:27 +0000 (UTC)
X-FDA: 84961956534.10.13EA4C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBDC1180004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:47:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dh2ykrRT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783428446;
	b=Zrdh7XQSGVhsYsGxOL7HwqJ6o6by4MsvBSGb/GIevI0s2papRp4AIYavDtFaLA2uqDOEb3
	gtxVOkIHvKUmikFl5WTl/9aqH3UDBxWUDfWgGhTh3HUI/a7P2Qr2DM8GtOUutz4LEq0EcR
	XKuuSXNOCJnKAqeI1+JRI5b2V2/nKmU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dh2ykrRT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783428446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEE3m3WVJuBFnAm3gjDrsTE+bClUghMxtBjGH4/4pak=;
	b=eUBzhO0osjuGUI6rKIRcqJqgErU151tIkwSTqMmrTlrrLGbMqzyCj4FnQNbZvRCPpMBRRS
	7201Du44MmEQslADq8gsxQQitKN7DOV87PbeDvQvxbQEHNZSSUqecfFmoDqxbjinA4dZAN
	9O5M2Uk0xs59G1a+w8/NEx3wVJ8PKmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB8E641429;
	Tue,  7 Jul 2026 12:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F51F1F00A3D;
	Tue,  7 Jul 2026 12:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783428444;
	bh=hEE3m3WVJuBFnAm3gjDrsTE+bClUghMxtBjGH4/4pak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dh2ykrRTucW/VBrxB9M+J/VOLxuu8Lp95gVoTmE/Xe1V/jHHEAVNrNpBPWO+ZIBXt
	 HG+X8VMiuLB4EZ9AKx7hjBsSp++azCCCIWW/C337n6ePgDj45+2IvH3Ms3ctzZQW8X
	 kvD21TM/G5banmvITBwHlXzBgWdEgf/b1ajmy+3+asmEKFWAckNYgoCcpZDiOphpcd
	 VC4WI0myBdBHSmnabwjUPsIaXePp2p6H2sRRuYtoNlLoX2MW8n0pjYjQBDi2OQDdYV
	 ngTsYJmUH7nO8cyxfaaE2MM+N/yece/OeonxsgVKvveXcZwK+8IYV6OXIHuwG+j4Oy
	 r4gBfxReXLBmQ==
Date: Tue, 7 Jul 2026 13:47:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Russell King <linux@armlinux.org.uk>
Cc: Qi Xi <xiqi2@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, linusw@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sunnanyong@huawei.com, 
	linux-mm@kvack.org, lilinjie8@huawei.com, liaohua4@huawei.com
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <akz1LNXtM2ign5u1@lucifer>
References: <20260626073048.3595106-2-xiqi2@huawei.com>
 <20260706133247.145485-1-xieyuanbin1@huawei.com>
 <c11452a3-b918-4d4c-afd7-a835a1d0a3bc@huawei.com>
 <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
X-Rspamd-Queue-Id: EBDC1180004
X-Rspam-User: 
X-Stat-Signature: bdmkhcup7eh8f6d67fox3frs3zrj7c6k
X-Rspamd-Server: rspam03
X-HE-Tag: 1783428445-265113
X-HE-Meta: U2FsdGVkX18jchsc79GyaNHSuBuugKbKp4lYRNI3noo7W/eBdeg81oIZd7vbbDl7bhdqtI18xg8jUz9Rdn+P23k21np6raOAB454Yjktl2KMIdNvPLU4s/yjSv5R2ufMCakTikXWRF41QNUaPb1R77EkhNHE0RGISOK0uicInW3WeJjrbaUEKUc5ITbz5GkiuWpDoz7/OTBK249QJGxgtKpzvevuNCtzbr8tlmpsBRfmigpD4VVI/JlMw+FRi4tUfviVrfBRbaUAcsTNtGuSuCRitP0PlayztKmgNJlWbB3m2ID6XkVk3jdtPraaNz/d1w68aopoIRbIYGqoOcstkhK9sYlsdCzVJay3fenRXjq35VieDTMFrw4oj0Q/JJdWGLqX5oy5DAVjDF3jzKsPB1QTaKf11cQPQJla5v1XHis3RUJ2Y93iokSmqlg1Mo5rh13lXh5z/dAZbKTxsyrnCKDmY+PyB1sJ3RIEiifeCErJVCdy2SDGyjH5jbkrSH5/F+QjymEKam9lMMN4tG22dD0eQu5pjtJ0uWsRkeDw3pkcy0nPqxn8TemzssgA7dPpY7Z5s++KxKvWeQkXfcDxnfbJ040PWUdXTKGDXiQ/M0smzZCK/gjEfL76giJTWNVzqynMEt+StB9cgltBHkzfVDpmbuFsC9kkmPPa5T7VLDkLYAx3PGcYcSgPV8h4r6PEsZtzLIU/jegmxatFJ8ioI4fdYc4Lr/nKOvRMltFVRmEyX7ovkYQEo7EtZ8lpQTG66OfaVcH1YyBovxrmgFFFJVpKC06y7AO3NJRmU6+mKBiHWuzZ0M/Lf6EWz+O0gglG8qq+C5T4MaMHC0kOs4DUbPiIanRW9lwfA7IKABu/dLVByizZlenIwG6i9emDGuHLhBPn1ZbNii+2LgKRhShVvq3bioBmGwVO32tnqO528tm//MCNPne6AT6NhmvJQy/0TCrMTN9g6wt7/qek5x/
 qjhpaNNA
 btIFWU1vzqdCOAmF/SVdbXpDWCzzop9IkDDIy0+3X2LWmaRaGlVRlSQeUtkfQrirXUNpkbd4LW//bztAWSbTCDmYLX7eI7sdNTf06knUhKNdI4vdhMPA+SJLzIssFy9JrbclVMkHC3jAs0xzNKXvh+CUDoLdM0Ecxi+XUF0wxlokT3/HfJJd+Fbrkk6yTlCC2HbDEKkbOVPncQ2m3zXsPxlR1d3fw3Yk8x+WlDjLzC8Y5LzGJm24lSztUOP9UKL8n5kb4h4ntpgr6NR4pEdt0SxdNf2+YpO1GMggQK0qIujFy3qwpOuJ8SXgWe9Gh9SWwU+wEyAnKLcHht7V0cAHhBDlCywmWBTdsNJPb6gMg6RAwXBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:57:45PM +0100, Russell King wrote:
> On Tue, Jul 07, 2026 at 07:48:12PM +0800, Qi Xi wrote:
> > You're right. And I think the fix is to simply skip show_pte() for kernel
> > addresses.
>
> No. This information is useful debug for kernel oops.

Yup see my reply, just upgrade it to an mmap write lock and you should be
safe to keep this.

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

Cheers, Lorenzo

