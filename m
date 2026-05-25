Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF22CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218036B009B; Mon, 25 May 2026 11:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7C16B009D; Mon, 25 May 2026 11:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DECD6B009E; Mon, 25 May 2026 11:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2A6C6B009B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:46:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4AA1160642
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:46:00 +0000 (UTC)
X-FDA: 84806368080.28.D523E9E
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6E3D140009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:45:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=ma5UQJ+1;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g 8Lqc5O";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779723958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ip/pTMIAjVbVqPVjzKxY0lQR6jtS4rsHp7ki00Fhc8E=;
	b=TWFfh7l45D+we3Rpc0FbeMuE/kz0j/HrUogzhBXo01iXCFWTmoF0vLphmhZL8VBi3FmKZU
	dtmU9ODSrNw9Q7nofesB0K1nak+wNXZIBPpTHCF8gqmV3E0sWdF4y4muxeEwwOwMp8axF3
	l1dfq6kc7nTbFugpmPvnKm79DFj1K5Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=ma5UQJ+1;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g 8Lqc5O";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779723958; a=rsa-sha256;
	cv=none;
	b=sM2oDmAIb7tTkVY0y9STQWSfWKvYC6S1IVZgrk4cLXol91nb5Yk19RWz5hKuZ6Ht3KoE2T
	n9Ev05EPBj1nSQosZH0EHt8nCUYllsE31loaXHkN+gBJqN7/A5ijaoNXY0os7n93hUuQKy
	mLHR1BnCYLuJGruJ/XG2mU4iTmJM+KM=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id ECF191300B16;
	Mon, 25 May 2026 11:45:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 25 May 2026 11:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779723956; x=1779731156; bh=ip/pTMIAjVbVqPVjzKxY0lQR6jtS4rsH
	p7ki00Fhc8E=; b=ma5UQJ+1HxHUqPl6eHviAS4IqTxG5x6lwemNJutSnqkYZRX/
	GrdAnincetnbUBfJEo8Uf9Binwnevi5D4brGSTYGKFHZx8Ue8QQkh1DnoSkcyGdM
	yy1TETa0hxKnlrul3pD1urd+txEbmG4Qw5wSFQTBC7dTc5G117PVjc+xvraMA9gQ
	RWi5/4BVzH+rAcj6Xj3cnLaQOwWcIVCRN1esUqwHUImlTZJEM501TdqVlWVspD46
	OigfDKo2IQBKN0H1rH9+oRWkdkNedX8EgaTmZ7qRusm5KYNEvuFt7o6J2nzZlFkM
	t1sdgRkAjfDx9m7/J0nq0c7L7W5ZQbx3S/tP1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779723956; x=
	1779731156; bh=ip/pTMIAjVbVqPVjzKxY0lQR6jtS4rsHp7ki00Fhc8E=; b=g
	8Lqc5OdqrG8KVcqLc8hSs3+dCflbvacl4qMZJzpBWtPKrhu7Nls17fjYc5GgdklZ
	3FylA5Ip2wfIWi297udqMADlhkwE4YJZsPDBS96a8I77PxVIHpnDgJ5FdwySPq6F
	kMhFSF1AhetLYQkfr9mCoIQW6e+2GGAhUarETgqw/PBIdr6MFLu72sKsdwyFoTTG
	9YVl8rliT7CZ7xqzW3nEV1VgyXWRxqZlfqUKNq6Up3q+5g2lL4KqYrHcJK2fUr6j
	oL57I0klUS3XZ6jWsXiv72ffBnKVj5RTnJnCJZ93khR2gapAAewwAn74/AGKlong
	1cHReWprQ6eNXAQI04Qpw==
X-ME-Sender: <xms:tG4UarufJ1pS8yJHvq3sQ3JXMSH_JXx9wHgKsymToNChwnvicHSaGw>
    <xme:tG4UamZK_AcXR1gdbk3xJTXGRm8Jo77KCsDFsF27kYDMSM-I3X2Dn1Tk2tOtqqUPl
    a24ggKC06zWm_-AO1Q76pCaeDowOwBFit2qjKqDFcuFcMjqtZGjuw>
X-ME-Received: <xmr:tG4UagpbKjNo4e8gkm7IcjMvFY77VTJfiHdvrZaTfCCUi_sgRsCeSn9RlewQ_g>
X-ME-Proxy-Cause: dmFkZTGEPse4hV1yBwsDDEa7O6Lryon99uUXj/XLpI0tprakm/YTBddT7aRX8pCTW2DPLE
    wxqIym+YUtlhKLJDWeGlCptVUlFMjgS9D7yuWlBIwCAwtYKi6zo0j4CAVYn/vgyZJPXLOG
    BYtH9Nh6HPuNoLdp1/VdWgbOADAvtxmistcJnr4qLuoaufELcanxBkRVcKH65VViIUzn34
    Kp2QKpFHEZKdG/bhngq9fPozMAPTXZBBmDnTHHXvVQgDsw5EQro4ZLXcqB86Oyr85j+lYE
    v7bqRum/AgTZ/4ycaOAngfI42jEaiRD9E5AlmyGSKpkOU4sWKlAkCcvM1cGoh+03YQwAYe
    nnqsVq+rVRt2NiwU2dBhlRF+qv7z8pqhrS5UI8bpuZZYV89Oi0hU0tgBFN1ZodV98iQb0E
    FW1DNGZ+w4zVPM0JtWFEgSKr7nkVvPN5dUHjpiTnHp72Jx2gxSPmoOiQ4ExnD8Ho0wZGBv
    4Mo136PpNq+Y6iIKKzJEDv8ioeUm4SjoHpF1WO9zK3BypyNss/gYi5SPOF7uqt/DdxE0WR
    PfNDy2+C2sdDdvfW8ZiSawPoYsGLAzWgsFqsuVZgFGXSF841JEkijnhp/52hP8runr/iWK
    jocfd7vA1jz/2HIV430lby+kADDjRfF97P22PEia4BdeDrDOS4HrV5bcbX6A
X-ME-Proxy: <xmx:tG4Ualo-E0bSbpj-R0K6c2ezKX7CskI6h1zweC2OSrwJERA8gtMaGQ>
    <xmx:tG4UalVIilCojT34Ve5jLdX1XGuXRxW_3nkk8kcIahh2npAT5u-SIw>
    <xmx:tG4UaqQRyFruY-TSYfH-QTZ4lgxDQ_51ZEacU3HVAbLyNx-AKvdwmQ>
    <xmx:tG4UapS9qR3zwCfHUz3ENlJXAmPB87qOe8UVK2Ix1mq_e9aQgW9ymA>
    <xmx:tG4UahyIrtMsYnxHF8yfapyuetGoRw0HB2E_MHPr0x8_ESmqG8oq--x->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:45:54 -0400 (EDT)
Date: Mon, 25 May 2026 16:45:48 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 14/14] Documentation/userfaultfd: document RWP working
 set tracking
Message-ID: <ahRuaePllG4Xo_Si@thinkstation>
References: <20260525113737.1942478-15-kas@kernel.org>
 <20260525122408.B74CB1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525122408.B74CB1F000E9@smtp.kernel.org>
X-Rspamd-Queue-Id: B6E3D140009
X-Stat-Signature: mdu6ax5tsquk8szyok7qx5re5361tbef
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779723958-144465
X-HE-Meta: U2FsdGVkX19HQD4/EFrZBinr8SFEzb8Ic/w3T+A6M12rk2t6gfZPX0biPt9vG99ewPSe77smdpIpU1Jz00L3VYucsDHWSpppTI8eGRimeBn8UwwLeY5mBaKfT0mGbX5+e61QV7riRyglHlhc/haaWJxohAcY/rCXJmKhhG2DLf5xDDBxOBgeT63XrvDBdwGMBIKWXY842ZOiOp9u+RAup/vQFLrA+OE8T1qupMwWye1EGwHuByZjw4HF9JAItP2q+7ZapVvgyk19daEsMvhAZ3ywUpMViU0LWB/rX/e0tD1aEe0X0TJ8r7l6OiP/CNl9L9PlcxBgMv5MdPd+iURNxNFyrnpBPqdUVpNoOP45KPAQSAaEbVTjnMMfjVjg42+QUKNPd5T2XTeabuTa9qZEHMNOZZ2y9cwJ2+fqgwf9lDuSp/1uEbegVvCBStYDBUT4pwj5re/wxhvhUAVywOO9PX+13lJx84QrsTthuFuvNRau88Eg1jb8+7DoV8rosrLWzJStGW10Oe2pEGmvHuuT5bXyehWuHnypGZsz6mKqDcpNr6hk8+vmKjjFEDn1RmdmEfSXVnyt66CYWimxpgLVwxpaUMklxmKxO467UaAfQIBeljoeoabdMzdncLmx/5I+qxpuv3F9umoIFGSwnL+KufTUUcsRyHKQNbw4oJNjWdhzHQxI8/eufub45CfMhmnmMyH0pro6pYZ3Bjgqf2bVk3TaZK7B32Q+Gh9B7JdM02A40jQDezHlzg1zgwmavIWllH1tdqzM5uIDlB91v6BlSIQtwrx4nqFik22GNvy0fPd/NWTGcqoTBf8EI3OvuyWhUvBFAtVlO5EQBr+TPtjTq4/hlXn57d/Q4bQkOHBPx8DvYLTNP8D4wE3SBqBy50CDp1DNq7QKbRsodNhTZZCoxOsco+gPHk8RxKwGdV1oxZVh5+xisShTaJnS7kAB3123CKOig8/tmFPYasSzTBx
 HN5MONmg
 POaBOEOcvYKXwmeTs7Dnd12VlPoMHv3ZgQP96SMKiT3Fh9eKieVIM97AJc66FEzLLNX/q76YH8o/SrhLKNZA0OhP3pPaN7IoYLHF1TN3ovdbPcZdkwLVa87mtRvCbWgmOOAuRwpNjUCBc/Ynz+5xE6Z4UUZJYhWrhYZwG8a2bobVR7RobgW4utVUGnOEFbiMgzHqwXdiCf2GgK7ajb6JLFLucehXoRWNMwBDobbIQ3hXDp0qnFofS8xAB9g6sniyuN2AsdlIwEWulghDTXx+0dX1KmohJ0vQr832XxpSlKF/fH7NwL6ReLWy/lZ7DueRedTiZ3WlHdWrPqLyN9Ci+nOzNndIFcrPlG4jxjqlTStjMLRpcBOCvwcz1Xz2P6VIQkSdXMw7humRQVvAhWNHqn/a/xDvIsmyJ7pBUkIDE5gj04ZA0J/Ge/x7lWwqRSS15HZjUDTteG5N2Ty1TpcDwDjhsHgP+2qRVrqLFm6TrkVQ6b8GJEPikDXiIOxK1405jwSp2N0ADZ3zQk0Esps+tva9WVf8W9EyWXBd8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:24:08PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] The documented VMM working set tracking workflow disables
> async mode AFTER performing PAGEMAP_SCAN, creating a TOCTOU data loss
> race condition.
> - [High] UFFDIO_SET_MODE relies solely on mmap_write_lock() to
> synchronize with in-flight faults, failing to exclude or drain per-VMA
> locked faults.
> - [Medium] The example code uses an anonymous compound literal for the
> UFFDIO_API ioctl argument, making it impossible to inspect returned
> features.
> - [Low] The example C code contains standard C compliance issues and
> an undefined variable in the `pwrite` call.

All valid. Will address in v5.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=14

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

