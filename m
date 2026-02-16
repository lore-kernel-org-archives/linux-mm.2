Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F28FE81A24
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729266B0005; Mon, 16 Feb 2026 09:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0DE6B008A; Mon, 16 Feb 2026 09:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601BD6B008C; Mon, 16 Feb 2026 09:25:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4346B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:25:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D03A8140DB2
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:25:20 +0000 (UTC)
X-FDA: 84450542400.03.FA505EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 501491A0011
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:25:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=th7wjGTX;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771251919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oIu3pkSvSpCbBElDXLy1ptgrph+gMWaZ/fnS4KJrpw=;
	b=Apos7ogWIRMyub4FHW4SDkvuOLPBn/MwnyKywyU/VKBn8t30CcE84Uo1RPHu4i6nc3Uw1H
	Dr3SfGvLbvz9kUHiJgdKG0sNozfF+gmLuOKbhepTwWagN5UPAy4n7GdFBn5uVRDbbZKzau
	ORfFSsvCtksx6Hex1sXZNtEQWGQWWw4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=th7wjGTX;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771251919; a=rsa-sha256;
	cv=none;
	b=qEB2jjJS41QdLVYGGtIFNcjJvynQlhZX1eON+ojx0GPfJCiQbpkvacL6KCfkTsf3obZyqj
	18Cnl++7e6mJTx5y+gAZnybewFGtlQlzAUF7jGmiYC2OBZ3qWNd7kaVXvVD8SJazvF5J9f
	yTEsUluuhKPNLWAboaUmHntMHIYydAE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A2FF600B0;
	Mon, 16 Feb 2026 14:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA21C116C6;
	Mon, 16 Feb 2026 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771251918;
	bh=kCGqJIaDX5f6yv6thjxkoZ3TawsKPgZ0E8IC+FDXC/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=th7wjGTXhr5+033pNx2RNmqJOLEwrDpNHhH1xpvmxoIOtpbE5xKkvTy7mepwc3dF6
	 S10itHpIrMEe1Z/gww83Hw5Mb4Yjb58gmZqfx03wRUX3efqs+FxtIEoy/ho4/kkFp4
	 XWafKuyReQvzDqlRzl9fzeMo9gxUEblLS4V1u9dw2af6zU9LJHDYXrv5NB0UdBYye7
	 B7rhgBV1BIuhG00cuZkCb6iJs2HYgfGgMD96ObgR/RbAHbagGHkREfdCyAtztNrRch
	 KpZHhaq1KUGkRG0pEFSFKHtDiokVYiTXwW0AOwP8rtBnG0FN0tkBVhR4gnjfBIr74Z
	 M5Ar+FD9JGQsQ==
Date: Mon, 16 Feb 2026 15:25:13 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	lwn@lwn.net
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260119-bagger-desaster-e11c27458c49@brauner>
 <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
X-Rspamd-Server: rspam11
X-Stat-Signature: cc156jhb39cbpe3dx9w9niih151fsoe4
X-Rspam-User: 
X-Rspamd-Queue-Id: 501491A0011
X-HE-Tag: 1771251919-358776
X-HE-Meta: U2FsdGVkX188KTVipEHPXFgclj/C5SLBBeBZBQ/oZ1TYW1Ibf39jLVjrZrsfQvqOe/8+oVnv/8ByuydnU652YgZkJPfJpS5qMG5CJICTweQKEC5yC8FbMh7lo5xE0lwiNS4kMW/8K0W1C8uSStv51648CY5B0uKSJj6QfMybYZufY7M8aU5iKCD+wmD73cPOARNbfYnSKGCCtmhPXgdcfOrptpJeQZi5piBiqCOOai4pXJddwh1q9a4tMELcczEd0XVtfREIXbvy4zh+jG/HIEdLSVEip4Z258E4LNAyT7Z9hHpRnjiItkSy+t+2ifg/RATpi6wCblRYOZYJBe8lSnWuVUyDWZHY5zM2OuDmhdupWbWLMJGNqPZg5fD05OfLxzFRK2FzYjldZA3lPAO7KOSBNKNngtadPk1WbH6EC0DwDEBe19pRxH0wgHE2j8jOOXuzOMxWYwPlUAaFyweo9WPd1WVwNmnIYv/nU4qSUtNiwiuuIAeC48S7Bx9vg/iemOqwMDtC3x4zzlABupYrV7QNtPqWZ/C56QEPd2c9k/a3kv8hpfa/VYwh9B7Fi4bCAgYtAIH+QnKIcwezPorZRkXVzsU0u6/nEUGgX0cR0QEjQb/izp/yl4lIrn0JaH+2W5nE1unHIrgNzB9Xh/wtNkopEnAk0VSG5k5ldN7vctGxmZo97DRw+xoEiTDIwo1OLJy+ES20ksxcOgR6+n2IidntY6IQUKqA3n0Enatjdh6l56rrUvEseqbHEQR0TU6xV7gD4c29pjVnNhAwtrb5yJxnKaRRcVduBm7C+WqpCUkjfrkoz74Qk+aMdxL24tzMTanvwU8BCP/wk7IcUxAeXWVviJH2xfyxtAcC1t9e8vUSC1ARviDF8DaCimkQEDrLPnKm5KZ39EongQhNpWkiVhkAvAg/U1S0dgX+JYOY0oR1rkLzgKtL5nuSCXYdZS603ln54TZrvTWemCtZxa6
 wP9uMKiZ
 pk2IXnWvFET+Rw9LuBTZAMoyXqUEwbECUuXD6qkAj8oXSFEWJhHs/BiSRlEtDwp6qNfGWoVXPeMvGb3fAda+iwWo2six8PwR06lLwhGqAonDXclKSCZe0Rnj3Vg4qDXnuAKYBdiD0LKp7H7b+xFjRH+y8CShnXXWFK2XAfPpTnd6IXiEHRTHNo2BLkLwVQcHItUyLyiUnMwdMOJo9cGqMQiicIUgy7273e1BqpV8likdNJKNl2xCTqzL/9bilcHB0/cGvCB8zr3BRJpKg873hRb5I6ScqCcqzK2aJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 05:13:52PM +0100, Christian Brauner wrote:
> On Mon, Jan 19, 2026 at 03:26:39PM +0100, Christian Brauner wrote:
> > > (1) Fill out the following Google form to request attendance and
> > >     suggest any topics for discussion:
> > > 
> > >           https://forms.gle/hUgiEksr8CA1migCA
> > > 
> > >     If advance notice is required for visa applications, please point
> > >     that out in your proposal or request to attend, and submit the topic
> > >     as soon as possible.

This is (likely) the final reminder to put in your invitation request!
The invitation request form closes this Friday, 20th February.

Fever has struck me down so all you get is a bad limerick:

There's a conference called LSFMM,
Where maintainers debate and condemn,
They argue till dawn
What's merged or withdrawn,
Then next year do it over again!

Don't forget to pester^wask^wremind your respective organizations to
sponsor LSF/MM/BPF 2026! If it helps, you can tell them that we're
considering renaming it LSF/MM/BPF/AI.

Thanks!
Christian

