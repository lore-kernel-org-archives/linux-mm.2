Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD343606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=BRs+t4ks;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Vx/K0IlD
Received: by kanga.kvack.org (Postfix)
	id B860D6B083F; Tue, 24 Nov 2026 13:54:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DE56B0841; Tue, 24 Nov 2026 13:54:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CDC6B0842; Tue, 24 Nov 2026 13:54:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75D806B083F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11109C0CAE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:54:53 +0000 (UTC)
X-FDA: 85470914466.03.3BA4A7B
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf26.hostedemail.com (Postfix) with ESMTP id D0B5D140003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:54:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=BRs+t4ks;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V x/K0Il";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546491;
	b=RpGjV+h6k8iMS+VV1oJIXTKBdvsQ5yGizyhc5hg+y8n3qIqaiiUnNT3RyVMSwweP/7Vqns
	XBZiCdHNFUqZJ3Rr1lR1ar6EpbPeUwqWGqG6NqEA6fpxmWxouO1prLCmKCxmoZSuI2p94q
	WWDDodN/ZQZH0OA5aaJih4zs2Svec1U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=;
	b=CjBAP22axt4XM9EewWCLkP07ct+8ZnVzuVquqnu/LYNxk3IURzKwHqBAnFwc/cIWMeuNXt
	OPhbpJulpQj3X0ggLzSoH7B0sWX6H+VJkXws1IjDQ+X5ULYeTvzfwEmbIznFouIrZ1TCx/
	iiRLOE9A3FanCY0Fur6Qloe3Ict4hz8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=BRs+t4ks;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V x/K0Il";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 2B9B51380873
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:50 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 13:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795546475;
	 x=1795553675; bh=zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=; b=
	BRs+t4ksTqnTtE1oYjJwDc1C9K5jlphfaup5bA8IjY07JdlXNr3LnaRbvngocT+l
	0s8mpcGjn2w5BH00n8m4unx2HOzBIssG9G0cRWhbuMv2TLmdp1NalygFp5oxuPtJ
	wTAJP5SGdhazfnxYVfevwxTV6el91PqN32OZosleJtIwlS9tg7bn57xISyTR2cV2
	w8mchKYS54UTYuQdinubggxyt/E11YV+y1DBfPwx09QgOMJyBy4X/e1dzVXEdCLQ
	UfkpU0yQ7iyBQzG/lrKYkD+WJELv9rYSdR8XNg8Icg5Xi7DvSz7qRf9OXV3LCBtL
	CSzbMSwdg5Yc27rprTFHxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795546475; x=
	1795553675; bh=zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=; b=V
	x/K0IlDvDMzIOh6ytEGzD9KXK48W6+PlY63Pkk5C4LqO8corTR1AOL6M3C0HEOEt
	RnYztbOsrj/0nf6VZ7GNoKO3ESw2hQALr88flIWiz5nE2Vis9yZo/Ns4DfYzZ8gs
	HGrNVlz/fNpZlQyjnvQnlw9skxNMOmJEBOYaR4LGyOZQhwF7fyOi5lto72PKc/d5
	FXgv4UzC3YmDb9P8JTElHIgUuk8lUDGbXOVIkdWbLNNQrV65HVYiNE+VAzlmo2Mr
	249vwFX/TxOavA6UatGb13UOmLI4UeYjVkP4zkYTEoRL1UdTk0BTJTgoKHcSuG8k
	+lq6xcKwaH/EuXoPJowQg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795546475; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:MDWRP2Bj+m9RharlLo1iWK5wDzJazUYB+Gld7wS5t7k2JTb
	fKjxXiwLjgXoO/CC620G3RfCm+CG2cJLBp3bfLo0AepCtClycfqX6uEXK92buQtu
	LlHJHA6m40iM6Vl6Y+yfDD0XLMxpOmh2esIWJTVlJzg9nVsmBW/nzjbM9AhHzle7
	wMXEB6HOUupZoBmZYh/59zC6Zl6TLoV2hIVrUtLoJ0Ex5mR0wVW/H/dbbepx+d60
	PilHP+MK1KALZkzRiNRKs1lOxHMAJ4RdWf2WwHo42uQsfCPO34L2ysA/u9bFV4Ab
	+m0+V5F+oUbJ46OjFASLaEYpZHk8CRVkP+qj8ZA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:LzM4tAbzweW+mDyb/1r3509G6pq6a3/4tE8KTO1Vt/k=:zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=;
X-ME-Sender: <xms:Xd0Fa55FOfcfIgivK7gDT2s90l8T2iyzgndSBP-plhfJtABFXfc8Eg>
    <xme:Xd0FaxtsJcVSGFN5HVXn38MtsB8YALAp-Wx8fFhFezYcs-M83HeSNrRFesiuboQoW
    5UfpbOJWqvvpnAVz9GZ53DVxThH7R3ev1eLeyVj0ZpYxdoXqLzoT860>
X-ME-Proxy-Cause: dmFkZTFIFQbDkqPixxG6ZmbrNqWja0iBmS0t+/2OXw3Hr68jTmofYge70Jd2C8rdOHxiEX
    pUSI1QmY8wa8hdAn9aHQtwJQbrzJ92rRcp5Lj4ZnT7lqds2vmNLcn0UUOnmmP8hv3V6w+/
    4jmHwhmrL8ACMwHSGKtRy9Vnn1gbC9jBuNuwnrpPjs09zdYgYnDdJ7dHlbs8/Vq3FaRIg2
    harjfzAY/2DUVwFrNAo5sJTbPVeYuXkjeFTXI2vNrndIhUaMB0WHtTD9Snytzp1zPIggcK
    0Qu1xi+ImflvZSyP3jJ4f+Pj22kJds4yfs5MDHkxWsLhkYz/NB/2cV/kiMtdUnvlRqpyL2
    pa8DmP1PV2q7BXbNlBMb0LKR9J0cg5zWatj1ewFm/B4wUeq2NcKYG3p/wiHSLf/7MZkJPo
    55VBqztvGKRmqQhHsRaalq/b5qWlczTjuaCR4KHYJNMSuYr6Ue5sGaBM73CTNL8k5C+HeS
    6yw7flTH1KDfWZ2D/nTRJ3KwclHeIC555NIo/fbXlsIZrqs/aZ2GTd67CpM9d+D1a0dou3
    PxTyuQMHWomu85N198NFQNJkn2rRVPia1CBEDpS4YilQB2ja7EgRCyk+GRsdfBsMdfvj61
    iX1Tevck3x163pXwovYHvcc+KWnNS+6vzDYjKokt0XM2OTPlrT2Sqf+0nrGw
X-ME-Proxy: <xmx:ZN0FawFxheCN-x8-0Vbv0XSt5auhNbm68w5nEL_E_IUlqy9inlE7gQ>
    <xmx:ZN0Fa_SMlpnS-VL9ozFnJwNMSJnC9TJbQVcM28ytDW_qtr-tXAFROg>
    <xmx:ZN0Faz1H8jdefJwCblcNEhWmtX8FBEPKunscTBgHdHefzx5f7AFpNw>
    <xmx:ZN0Fay5HgQNFfUBXh7L8tyhCYUmn3ZM-G7JVXw9IVM5_sFauYfaajA>
    <xmx:a90Fa4VKd0seXJsIkfqSaHH9e6lytGZcnkXlwXg5yWyhKLyy-Iftp9hP>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1964B32A0099; Tue, 24 Nov 2026 13:54:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: ADzkAynZlS63
Date: Tue, 24 Nov 2026 19:54:00 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Juergen Gross" <jgross@suse.com>,
 "Stefano Stabellini" <sstabellini@kernel.org>,
 "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>,
 "Haiyang Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>,
 "Dexuan Cui" <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Jason Wang" <jasowangio@gmail.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
 "Jarkko Sakkinen" <jarkko@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.com>,
 "Paul Moore" <paul@paul-moore.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 =?UTF-8?Q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
 "Joel Stanley" <joel@jms.id.au>,
 "Andrew Jeffery" <andrew@codeconstruct.com.au>,
 "Ryan Chen" <ryan_chen@aspeedtech.com>,
 "'billy_tsai@aspeedtech.com'" <billy_tsai@aspeedtech.com>,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>,
 "Jens Wiklander" <jenswi@kernel.org>, "Sumit Garg" <sumit.garg@kernel.org>,
 "Scott Branden" <scott.branden@broadcom.com>,
 "Broadcom internal kernel review list" <bcm-kernel-feedback-list@broadcom.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Richard Cochran" <richardcochran@gmail.com>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
 Netdev <netdev@vger.kernel.org>, linux-mm@kvack.org,
 "Jens Wiklander" <jens.wiklander@oss.qualcomm.com>
Message-Id: <9a87f9a4-4299-4a9f-97db-578d7687a848@app.fastmail.com>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-10-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
 <20261124-late-2026-mmap_prepare-v2-10-0b0d99d655f9@kernel.org>
Subject: Re: [PATCH v2 10/13] tee: convert shm mmap hook to mmap_prepare
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D0B5D140003
X-Stat-Signature: rcyqb7hptzkhixka8wj7j79hb53ytwdx
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795546490-2718
X-HE-Meta: U2FsdGVkX1/Nf/ntmYDzDg5nK5WqRwZ+AZUzl8tMOJ6lsHYg0Kp/YpVEaiTvDUjQoEU6RxZN0iYXBpEmbXfwX1P9X4BWVYAt47wtgRv22xXdl9Mc/qnUBMlFuCnKEiCrAkwH+G2KLIgvbxH3juV2uWuRbmkH2/9TDr2mma9pkHzZamo3JawvpPjfUEGayIiWH/63NwgNnZ/e2mAMhUg1qPqmOZ+/tjKNih7SuT/xCAwJrJDa9QaZxFuOsXs1Mos1kQ9mIGaCsPIora1rHDaedflIUsHiniRdRWuuaG6dNTu4mTuHHZghTY1BAWuzkmnI4vc8RKX+ZKbCcG/7g0PE8J/YbiaKoVO1+/Rvr+iMZB6z0JPHdsTkFQlU8/1h7sHZvEfLqqpmSGjXn0u8XUUOI+rmDUKza/A3UAqV873UzoUAwenlD4j3tspmDEeSvvAITUrGcJgh2oYt4PrZqhjSvi8J/q37aIZAFZyVroGsEawCi0UgcRTN9D91YzIjiJyd+MAUVmEhDD4ZVEKf6gmPGRfapM3KRvLxRGFzaPQyOyLkuVSnACUmE279giwMTlYmt/yQgkn501M7bYE3M2gIUQKqpA5rky46eYzBjitrjwcNmNoQtXnTJ3cHSuRvsJ55hrPHjyfSXHegB9caIal7/zEbSo1iPpVH2kRaUvZRSDNrCeuz41pY3+nhgDV3dhXQ2dxr0cc6HsTPwk6gjlbqta06N45RMAqtkWTB49EMWu+ktp4H27coHFK5zYD0Y2tSlbcYDZIvAg3NG4bkENspoWInpssAKno4BYXbM9YwtRWb7NoVVmwBYRpAOlzPqWWrPx8aZvwcr8wDxoxS8CnkLZ/mHy4u5IjuvdOa5FGx1ZkiNofa053aZ66dPpuARdE4yG4u25HbkkL3J9g5/xNhScnjFq36Nj745iIGKf5xgjoPZrsrJ4NHwk6Mi3IaA+/MLAm2NBX+QSVGgoMHjZp
 dB0q3qmz
 FiNknrVL+lpzWH9NFDMtKZbKqg+JRUPomDkxsppxzUDtpH/2MpqNPRitznOXcmDJyft40Sjuuh9Mr0/VyW+2QPadWM+Rfxwt5XZxkcFfGd9+obwHYBj5GJ+GisS/sFbS0St40tkzLIwPQhyFs8B3itbuv7BYVd1kKoYqk3aSUfGfVMD236mlz4AkVrwmfsAwsMf1ywfWYO7TIYPJqjOeUFsE7/7s1iU+b0j1PXWZp1Ezd+1GFd/2Kr74tlQvQqVwoWdRCMEZuMtsT2AjmFTJUbN2RXsX5NF0XIVH85d9CzXKkO9mPvN+8HuWICSZQ7xr9Cf2vmb8K6+x2ZtZAvM1CBpZpqhNttITfpvKkOh9kUTK602jejqvE5ZOjfp9XC7iiRqeN6VxkTjpNhoSHdc05B5o9aUnTpRnNHQM9489z1SHeA3N+wdGVKCRjLHqEltcwFeN35dT5P6yZtzbmzAsUYYjvAgsIyJfYAuqz19w9h1iaPGYHu9jxrY+ncMtyFr7X1a/OimSc73tlF8HBDyWycGlQ7/QSY/u/QueIH00ba3utduJTm1LAn4fSYkqH2hGkSWZf+Ll42Ojh+jG4K5V0Av5qfPJ9UdWNNerHvd5hpzx95uKxIBlOAG+LNF6j8V7ZM8PqO3j75p9LzgRSsGMe2Jx6M0hsigw7eiZLgObUMSMo301nyQISXeSMF8g+ZBixrrHRIpYXmfnE9Vy3WtPMUN/WM7th/ACiojy52Cp97D/Pt7O5W9Mw67c9dPj4lXv95Vj6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026, at 15:02, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook, using the
> PFN remap mmap action to map the shared memory.
>
> Reviewed-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

