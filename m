Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD38C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97E16B00A7; Tue, 22 Sep 2026 05:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21A06B00A9; Tue, 22 Sep 2026 05:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37AB6B00AA; Tue, 22 Sep 2026 05:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 902E66B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:02:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EC951C283E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:02:14 +0000 (UTC)
X-FDA: 85240806588.01.578D81D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8826416000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:02:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ho1NxTfY;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067732;
	b=N+w+MsSWXUfjHBtxIPUyiR6Ooq7qyf1j7SGY4Fin8EBBeXOhD65KX+4PiIMChIsdGJ1FF7
	tUTNzFniMpFaFC9AorAkyCnEUbwtpb5E06lFgI0PQKd8beFV5t3tM5n3STGoyAFC3WGxHO
	ChP8ECMxWc6CbBRII0QAzJpQ8jDegrM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ho1NxTfY;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067732;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hsnJ4j4rBIXKKH9ChIwWElTHO5VrNa39QD6tMI8Gqk=;
	b=KvGGuce8PF5GkpRNvDUOcGC59YFbjt4rwZ+AWdzXXDG17KyjvYD00E+BJeo4bbIl+VgEjH
	J98qz/CX2Lxp6IdrxiwMwxEM8ZUfKh5mqBUswxIiTlF9EtF+Ej8xB7t6UiXTniT64moqkE
	scvIL2DYpbEMIynMNdurcRK2PDxkvAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C7A660200;
	Tue, 22 Sep 2026 09:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E505F1F000FF;
	Tue, 22 Sep 2026 09:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067731;
	bh=+hsnJ4j4rBIXKKH9ChIwWElTHO5VrNa39QD6tMI8Gqk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ho1NxTfYbdGdeqfpz5XyJWNcpb+7YT6deUPOb7e/Es4jmHjJWSyriPfAAGuVspsae
	 6LKxXVdN1I2udTK271j3pFm2GMHS0XZV8KVHkUGVtsYFv5r2COfiRTH2Y6ht/kxwzI
	 5S7K5mqn5YCKOuNg/yGFFk0fqstHlUc6g6O3EF7XYzAKKBM6Nc/Wql66LhlQ47+4db
	 cKexdcycBQ4ogjwH9iqe0dPw02bHXTGuz5lPnWXYIFrVHZPotADEAFLZn7OCXa8iEW
	 al36CmxULEHPX1q79eXSdQseKONK2FXJbwliGmrP2a2xZ+pxm9/S+EEg+twlKbQ1yZ
	 0wPGdhtnaVu7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 9/9] crash_core: skip MEMBLOCK_NODUMP regions when
 building vmcore ELF header
Reply-To: sashiko-reviews@lists.linux.dev
To: baoquan.he@linux.dev, m.szyprowski@samsung.com, "Wandun Chen" <chenwandun1@gmail.com>, rppt@kernel.org, robh@kernel.org
Cc: devicetree@vger.kernel.org, linux-mm@kvack.org, chenhuacai@kernel.org, palmer@dabbelt.com, linux-kernel@vger.kernel.org, aou@eecs.berkeley.edu, conor+dt@kernel.org, kernel@xen0n.name, linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, will@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org, iommu@lists.linux.dev, tglx@kernel.org, pasha.tatashin@soleen.com, dave.hansen@linux.intel.com, x86@kernel.org, pjw@kernel.org, bp@alien8.de, mark.rutland@arm.com, ruirui.yang@linux.dev, catalin.marinas@arm.com, hpa@zytor.com, alex@ghiti.fr, pratyush@kernel.org, robin.murphy@arm.com, mingo@redhat.com, kexec@lists.infradead.org, linux-riscv@lists.infradead.org
In-Reply-To: <20260922084256.1515554-10-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-10-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 09:02:09 +0000
Message-Id: <20260922090209.E505F1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8826416000C
X-Stat-Signature: xz9krztun8j6za8r3e5eybdyw1q5rbsq
X-HE-Tag: 1790067732-607455
X-HE-Meta: U2FsdGVkX1+TBkLvuFGsMPPeG7zsuGHQBaJIMfWADYAEg97T3M4FColboNWhgjv8D5NuxJe1oVKN0B65Ymm4hLldaxXDPDS1QO5MR4Db50uLazxPd4AcDywz3fHdvN3J1/tVEa2tr+M8PYou4r9k7rGMpBV9TdRrrfcLrPq58okDCwKtjew2jghBpInyxY5cpxi/fBoEfF+8uZD41KcMC5alqeh+3GDnQktgzgGK04lJrKXfY4gK+6Sz3SOV6Ks64VCzsP7lmCN+98xIr18wImGn6oY2ii1j3kaQ6BtEn7h6SYpdzAwBriaoXCsFXprTZP21LXA+0izk7pXf33ozn9R1NiLad62R7Z9MngQA8fj6plXdgVMsttscqkKAsdHHc+Yk7BDGJyLDXwNecnQgP0ovS8icuZMspkROtnQnSREEXRf/iIplRlqRj1UwdmJSaFGfn3pc9KqW/dt1zIlYicy0jj0Z2faYzXzM4YIVQBgpUr5EDrE8aPsDECnE6w2XlIWK1AqQPLHbdLA5UTcTqUXNEIGMG6N/iUfP91iXHkqj+50ASERAjkjb8tIpIs63tgVnJkRY9X4cTHrkxen8Lm6481tRP9e0YCeI1dVURbmBc+U9XfiYSmbRL5l++NCfTsp/OtAcD4egQLGqXugUVD1LYOnOME+jdQZTVcMtNgse1XY8SGhjPP4tuqRkWXnc/3xXuOlDtKd7A4op2Eji7Bp1hVSS2MUcUCQ7636AzMOeEYNVJsq6cIhv46h95DfYKG7ZvGM6pGFeTmSxU23GdUNFs5aYtrkOOUqRL2TSYYsoyfKLugQQXy+thrARenWBoJQs247MaeJr9vOcOZbKX1z6JtnhrBrG2vMv1fDx4CQKVwF5WlcJVr1iiOhwhqdmGxo5dNX531pordCGPTEtoFv1vzzfTDyqo+ynspDkLC20N/kTAZCGo0F+l1U0NS9BzadkQQJlxa8qfVg+Jxo
 9y6rUtxQ
 QFZxmX8q5GYYU+oSPhVoSLAZpHW/q+2De+0nn+I5ZhO5iiO6twbIV/z3SO4mN1z8oQWd2tBmpA5CFVMmsN6I7EcCe/Y1S9Tc/j/bm6nNR7xs8FEGRjGfL7UgbhHqMxfOTz5IVNCd95dSn7oEJZgaNx6qtLLLRczVQhvdp+s8l0doamLknpkiNvHpoijrdcp+Mqnb2V1kumiI7em9ghe4rSDecC2OPknXpgKDfQoRnZnSNXcoioT9CRz7wPUUF60PD06uvaXELhje1oMJQxVB83OZDJIVzmPTeSkWkJ3PYn1X81bKIfOQPdjiky9NAB5NjS6DXi1YSdHwF6r2kH5cSCXi5+mPdY6qFtifKqkg0ftPPPNJ7EMAvtln3sz2HFTW9JnBCTF7vHWsjUKFuEAEV2+EOkXiEvEvq5dVBjY1fNnKB8cNLm4wxivblG//Q9Mih7tE0uKpwVNoL1DWzwDMpfO7RUYyxmqfQSMfppQ+Nkg/efRjXD/6CPHhx+c3dPOCATpkBkDmXERuYvI/t4c4upsJSmycWintddOKnbpOFCkq+ukwv8ZEuQt5KFNROi8uIQ9BJlx5uPbcB+w4MnBbv17ZH7MWXEUmFX1LuolW7QzOINNNZqvTrbe9nrziajgd8T2bQ9yCI+9SkSoGL0hGw/qvnPMmixppf5xqgd7pG6DGtbOUtsOJ79CgC+XT0pnFg0+b7YdBpNMK9jemi2iVva8vRxzNgkbxyQfduE1SzMerCKYk75L8pjil72sVLwQj9AUvK7YIHhdylPEJxrhJmCxpJATx+8l3D16vBcaj3hzj8xzmZc1T/MDYrvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Wandun Chen <chenwandun@lixiang.com>
>=20
> Reserve regions (for GPU, DSP, ...) carry no data useful for crash
> analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
> reduce vmcore size and capture time. crash_should_skip_region() now also
> returns true for MEMBLOCK_NODUMP.
>=20
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D9


