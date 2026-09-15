Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8DFC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A766B00A1; Tue, 15 Sep 2026 08:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E036B00A2; Tue, 15 Sep 2026 08:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44DA6B00A3; Tue, 15 Sep 2026 08:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD35B6B00A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:15:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C66211C1F1B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:15:01 +0000 (UTC)
X-FDA: 85215890802.16.9571D47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 42EDC1C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:15:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPGWfVIh;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474500;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRMZ7mmRdl98Hr0Jzx0dLUsIBC2R/cA4CuoG4//bR+w=;
	b=iZOoS5Vo9LN824BDtq4+3L58Xnb0ViVqtbvJWOc3Y491Lw4wE4IgfR6CQ7nJc/cmdO/3Wv
	fRrCVRKvuuc3a3kOak/JBlVrGKacG4REdocfHazVAJASGF72g98KCln6P9S6h8qmnFK1R0
	sq6f2lcMtAPJeSZi4qAwOoxNT1wtrdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474500;
	b=aXiXDhaW1QNkESDRIp5M3tsGLm/g/Iw20+EYNT2Htxp8mtcFJoYEiFvvAouRLstVFF3lBO
	36DFNVbcBf4OqgonFE4UvI+WkStlvwR3hQHGOkTSRest0rxN4archM+qVZtUE/0V6Bhzz7
	euMHdU1sWW+o7+fC2YzMJFQTWPkVmtI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPGWfVIh;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5277602C4;
	Tue, 15 Sep 2026 12:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD1B1F00893;
	Tue, 15 Sep 2026 12:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474499;
	bh=QRMZ7mmRdl98Hr0Jzx0dLUsIBC2R/cA4CuoG4//bR+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XPGWfVIhJ/wSL6Jd1KV8QYkaPXQevpxTo5YKyPKDIrxlw9MIHMHo5cZnoqRuYBPzW
	 YAB/BBxKyr04OnAz1fXuFsMiapL3vJK/RuyN3woNJu65a7GotPewX23h9YHqDCxQPk
	 2CWF6CYq7PbvZJuYpGBlpn9YbalxW+tFPh2E8PMbxAki0JSstQ2YNM5+QlpENVA4OR
	 4S8OeAn9BG92ITePDtvvACim8Vy9KB2TGUTfda+kW7PhqaNdVyqOBZvhFMBFu6IU+R
	 cXVP4LUVIrc7LmnOQ3vKo+sFLx/fVgoMs3/93rCsxZ1sqN6D06XnUMiUCyDHo1Jf2m
	 gcjyzu+b66/Nw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 37/50] tpm: vtpm_proxy: install the server
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-m68k@lists.linux-m68k.org, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Peter
 Zijlstra" <peterz@infradead.org>, linux-arm-kernel@lists.infradead.org, virtualization@lists.linux.dev, bpf@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, "Eugenio Perez" <eperezma@redhat.com>, kexec@lists.infradead.org, linux-openrisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "David Airlie" <airlied@redhat.com>, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-sh@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-alpha@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-csky@vger.kernel.org, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-mips@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-gpio@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-arm-msm@vger.kernel.org, linux-parisc@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-37-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-37-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:14:57 +0000
Message-Id: <20260915121457.BBD1B1F00893@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kx7nfumypf7aq4iqwdk646ud44t7jrha
X-Rspamd-Queue-Id: 42EDC1C0003
X-HE-Tag: 1789474500-589425
X-HE-Meta: U2FsdGVkX1+AMUdtk49s1sRiNMaRtyyxh5/NGgEweAFB92fdaglilWeJwPgJupXfkm8T/9a01NuHHlJuOLPRNtL8SXj8xCfoWGTG907YW1nMppylxPQ3TGhwlts+2FGW2jLn2BiJl3SFL/qiyDVk8DoNjz6+tyeqEZCGdlvWG1BFKoa5+s+dY4NgiH5g54BCTUh1Jtbf0qU3WcJa2BwzxtvuY56jObdecW8cUP2mTp5CE9sD0vUh5v6O80HOROWGAar4euIBwmKekJK7LEZgznxNM8egz/SPWpcB6P8oNhOMKNFUP8e1ATSEWBmHQOWa5Kvb92zAgLTjUBBtgcB1AwayL9oP6FAw8u3MdRHHwDei2WmeKp/+totFw9uLN5AdVnbUNPYPd8cFHxgWtMM7apIlXuVj2hD6qC695/A7hI6U/aaGLCjJkwVGTlLZzWR9/1Umk3wNWMb08WiNaSD6bAr+ENUmP6Hm9LWHzt3JER5ow3AlXIZI62l7pPIFz7ShoL2loOfVicDEazVT4HkGiE5Z7L1cjwG6M393ubgKBwL2PWyIE4B+XszjYGMO+yxN5/xD14TlcShgYLIvd1hqY3Q74X074j7PsT2Dc83YWno8+ZNeYaL7zj3eN807N7TnkL29OJ+/FJwqX4s+JOhcozXLoP85K4EOdhvyRqO6mN/cqG5q+aHp+BTcOXnXQcwT2zbvI56E7hSUir0LWcGN1mM2YJFy5ftotSexVw3xdKpwRPl92xcK/BlUgmWRpaI0kyKxUWQU/Orl7Db1elZ0AXlwYsZqzOhu1SH4OllYuPc5t6wTDAFEzliNmgEmb0IyNiJtHIfrQOp4MkLw/hgJmB2WX/zTkMe6OpuHVt4BSQvwvICNg4CqPQ5ab+8++Y1BRcs7TinuwzZyJZBTysww56mG4NEhjcbBKntO7TnAbmVna5PW+0NIkqMzb/I/ArIw+jRuPe7anROo618aYII
 G7RpMNgE
 ZbvxI0tjzwdVn7/3PVNSlQ3DBq3czo6rhYRzyxBKkGXU04nCKxNw9M0ZF0OQ1lDoJ1p/SMisCzbA7F5V3IpdNfZdR4BX0RXwPhnUYg3TDPYGQcVMZFMI7piOg4VnDOnxQdtimjHya01wu//fCknu6Hz1ccZZSwZsJeOFxRhSWqb61BbDlalamQRdCqVstnMMR7k6EIcxMatNSWVBLcGew+hYXU77BW52nPC8MpIIv9Tjv3G//SSFyb/AOWUZzvfrhk2XqJH+hRhPixr2mIYTH9o+riZ1E7fwQ0XHCpewGooH4RRNleC20y3HEoBQo9asRoxmaYK14SoTEyQeUgUU2OW67hFC8z6XCiXRnwvAaZNFoG3IbiaD3HLVWdzVng95smKV9oT52IQAwah9Vxt3hrmckSC22NhY360VAKEGBQlGJLxRV8kSkIBAUhkjxAFBVT222VFXAFOIB5XW2GNByNOA+X2H/O14+xV/0Mp2BP73YMrJDfB0Tr91u9LQUzddKGdd0gu44T0ADpVFt3tJwJC1xD6N2BKY4CXRrichLuRW2PSLJH++0FOjstp365c2PT/zgtEXGujXrQuTVzQL1g2vh4RIwc3qDFzhJkyyv7kT3HX8q1yl/sd3BVmwmM0CanEKWfwgSPMVQHSfLr/5XKJrJmdVU7gJiRPuGeOUIkeaBFPe7e3mhu3O5ui+qo4z0HKutm9VGXpqCXH5jclhGVYuReShsx+PHve2CH62XfIDnXuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D37


