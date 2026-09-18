Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6F9C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB096B0095; Fri, 18 Sep 2026 11:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2C16B0096; Fri, 18 Sep 2026 11:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6AB16B0098; Fri, 18 Sep 2026 11:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A57D66B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:28:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AD3380720
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:28:48 +0000 (UTC)
X-FDA: 85227265536.04.EBD2553
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id F350D2000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:28:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=giYkClqm;
	spf=pass (imf31.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTa5dNBMtLMbqJuICHOdAxEdGAM6oHsJ+w/pWPbR580=;
	b=lwulI2dxwpzSn7aYIChYXOLJ8wLQl3njMj07t0uNKRmWDAMmYf7cf+332WBl9oBqMo3V6m
	OCK1J5YHF8VNLoz2wgxU0cW5GH0qZVItH8NwhZF8eht0X/NN+DL6NZ5f69f+NHYdsP6d4r
	YmXLsbcFHImp2cHReJSBUBT/m/GeZYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745326;
	b=nceQAjXFhXuXtLKL+6b3goscm7wOvtJgNHcU/fiB8NUvWNnbOU1p3IsUoS9dfoPFPAcYCO
	0SBAyILVxfG5FL6j7BO8CqsOOrGdBEXoyJ6OJ6+hTk+NHNchbSV/6yAWXaZ2nQPIb13H2B
	wgBMtaFjR3lLp0M8zokuGP/OLeM6gAQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=giYkClqm;
	spf=pass (imf31.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789745325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KTa5dNBMtLMbqJuICHOdAxEdGAM6oHsJ+w/pWPbR580=;
	b=giYkClqmd+gXEb/bqARS6GNgArsGS0YClnE7BzUgHdgMWHahzvfsNODSmOGcLfg6QlHx7s
	bpw7VJjbui6h3xZ+9/HuKMVTz1DJCtM81l2l73Lqjz50xEmfuxLgh7AUqXxDfwTgNkPPCi
	ZQr9eXnSkp7WDCImqwN8iQdwnY5NzBc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-oVWIackBOVqwZoBNA5lM6g-1; Fri,
 18 Sep 2026 11:28:44 -0400
X-MC-Unique: oVWIackBOVqwZoBNA5lM6g-1
X-Mimecast-MFC-AGG-ID: oVWIackBOVqwZoBNA5lM6g_1789745322
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6884E1935DF7;
	Fri, 18 Sep 2026 15:28:41 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 1ADB130001A2;
	Fri, 18 Sep 2026 15:28:37 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 18 Sep 2026 17:28:41 +0200 (CEST)
Date: Fri, 18 Sep 2026 17:28:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v2 4/7] coredump: parse a snapshot of core_pattern
Message-ID: <aq1YpFX4ZNsgWbfR@redhat.com>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-4-f3787fcda051@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260917-work-coredump-fixes-v2-4-f3787fcda051@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: T4_6rZzdmv9djLRom1rniSPHjFgkz_sSQYClhfZSo9Q_1789745322
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6tmjndi8fbos36uzyt9694qh17gdur7q
X-Rspamd-Queue-Id: F350D2000A
X-HE-Tag: 1789745325-490263
X-HE-Meta: U2FsdGVkX1/t5PSrSWGKH/l1xe+bKP1YOyFb3j3i2pSi/5SK2T3QyyyVfMuZq6gHqFLSQxRO6/JatiNLUfIaoMfSvuqgR0gdq0kS6cnmhvyjHLFmdDUSEE/qRd1uatsaB0YQEKb7kllX8Emis3aQKU2eoXd2aViPxjyr0YIY+3pkCRExt2L6xdH1GSeIuav4n4DBRb/6+t/VttwTREpOLT4dFw+9Jt1w+n900a7Y1rfhnyhvHFAXF1uPwulF4XF2PC+e7jdevHwqHwrbpcXGkCjkUvjLdlVle3grxLu9usmHCqC2iA8UQPr8adZBE1Oe9XK3SzL3B56xExZI9dB6Wn+Py3x5nZQXwJXs+4CQMWq1Eav3/jH2mb9MaIPNi8cK1cBJMYByOr0bC9PFDESEY16YZSynx2cEHcZVtByIBPMn4Tfk4CVbZp9BwMrd9p4I2MATdew22agw1OWUFWDxD+R+3mvCnlsnGFTO3oY1Ofui8iLQUseC1VF2IC/8IBFokfzekGWMYNYnX1/FoM6AkKCVxOmPASsJpMcwEiFJKlvpzqJx0mYLjrPH4sS5X1FApYfgIlYM0PPdwtA/Maw5CiD+8+gsHiMlL41DpdgACE7siAtgQcDaQvXB7bzcNK7HI+Y5a8wjU2+faLTFUzhXWBenIWHL54wLL+xIYMj2kUThSd+WSHAxEl23IverUHTC8tqvs8OE8WQcn2PgkuX7WEtz/kEIvWePz0Fb0Ho5uwmuDzrOnvLXL7bGxfA6nexIRF74A3h2TCGpitQuuSOAzA+1/YdA0el/WfuHlbzXR81fXZw22tD6I7q86sCUTzbZ+jrDbhALoqI1KtbtYE46AisnNwoIHIO+dfdyRmKa33Mt+EizESi119XnIceDnC+XXQdHL/CFvtyY06oMsf1IXFmkdAZSROkSdmnVh4ppY2kJeEgTr0EGadIEHuhNoIfy3r1FZwCIh9ixMTjnT7y
 Gjo7Ax6f
 N4ZrvMveSb0HrLzaUnr+dlRf3/LCGD3tbqQ2a9re+j3IwNwQe/wYep73heaXHE8YodSrH01Fz+v5fZ/qAaVn0GHHDPwo9uW5nWc2FKjTe3ou8iK+LWaUEqJUdIQORzQt/IOmfiG9eHjSSio0hhs3oqWANt249qn2zq1FnJpZMETboDeWOE8q8WrsdnXFjHFv3RbEYW1ZVS+r6oTwCKfhgN2HNfnJg8VWweVjmLJURm3ZMknwNcHeUoMdQ8AcMTVSsccy7JC5XQhx0+Ei6JJFVZPFObn/EQHmvM73jNwAMy5LwsESgh/ihPRyHcdup0mrU4WNk73wJ+PFyrEmy25N8zueWnjVFD+A5CkjT0YkHpJN3fx+eQcFAiBu2cky6RgEDnU4frtrMR6tI78LNLbzMKfY/8PjGtlWbPPlbJCarE4OOmR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/17, Christian Brauner wrote:

> +	/* Publish the validated pattern whole. */
> +	scoped_guard(spinlock, &core_pattern_lock) {
> +		changed = strncmp(pattern, core_pattern, CORENAME_MAX_SIZE);
> +		strscpy(core_pattern, pattern);

Perhaps
		if (changed)
			strscpy(core_pattern, pattern);

will look more consistent... but this is purely cosmetic.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


