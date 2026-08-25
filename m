Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E92C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 06:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10A346B008C; Tue, 25 Aug 2026 02:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9DF6B0092; Tue, 25 Aug 2026 02:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12CF6B0095; Tue, 25 Aug 2026 02:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D18406B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:48:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAD0D1602B2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:48:24 +0000 (UTC)
X-FDA: 85138862928.10.93CA6E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75191A0008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:48:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Epfmdvud;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787640502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0Xx0vQw/77MZPCbZ84SfEciUQ3saYs6QehQ1wJS0yo=;
	b=nYnwf6MOk9lbz93Jc+sTXAD/epefRvsrqochSyucw4fzOlTFfKgAdoZdovWJCQ02IFDodc
	3cEUiSfmaxk+tDQSR4Y1rtgj3FK6IJxaE972uj8m8w1q8ll2HjdRmmgv5SVXIRmtRK/e0G
	M7N0Fyc0P7KCBTkAywzq3j8k5+zsp1w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Epfmdvud;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787640502;
	b=50oUcaiYtlXc4My69gCZPLkMWG6YaXbp0W7jKXABEONbTuJBqryetmo5PHkBRK6YvTkmEP
	ac3agLp/mAJklHu1Sf6JkBopnlx8KntFspOPUGcgdOkMvqE4G/WyCEgdaM9L1x2o0RTax4
	6IdL/onva7V3R8y1/fMA+JyHhGu3o/U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787640501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B0Xx0vQw/77MZPCbZ84SfEciUQ3saYs6QehQ1wJS0yo=;
	b=Epfmdvudk9j+44x2QZk/1O6w5MbGM9XULg46ThB6ByC7vBXvSYLZreVxwz//V9wrrfxLJM
	9UyzRHGN2BpIMFa0yI2qXP2RRA6JbxK6rB7+gj+pJZeh7m5QwGwJLRRff6K6L+sSYytZF0
	ifFfVy2Q/U2KWconTS22QayYeQ446T0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-n-XQKI-_OzStJgHibaIy3Q-1; Tue,
 25 Aug 2026 02:48:16 -0400
X-MC-Unique: n-XQKI-_OzStJgHibaIy3Q-1
X-Mimecast-MFC-AGG-ID: n-XQKI-_OzStJgHibaIy3Q_1787640494
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A69E1954128;
	Tue, 25 Aug 2026 06:48:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.15])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 27BEB3000239;
	Tue, 25 Aug 2026 06:48:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: dhowells@redhat.com, Pedro Falcato <pfalcato@suse.de>,
    Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
    John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
    Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
    "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
    linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
MIME-Version: 1.0
Date: Tue, 25 Aug 2026 07:48:06 +0100
Message-ID: <798622.1787640486@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: QwFXuY0Bp27o0wUkZwYB1xnyz4UPzKTWPuHUmvU-QJs_1787640494
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <798621.1787640486.1@warthog.procyon.org.uk>
X-Stat-Signature: gkjypxj8butbq6zmh4eshrsdjg741dxb
X-Rspamd-Queue-Id: 75191A0008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787640502-564212
X-HE-Meta: U2FsdGVkX1+9p1qfQ3S3xUiva4ktmj7nJOr8J1br6KACX3jhp9Hp4ss85xpljPagSEmg3aQYvKaz9CHp8d1gZmpC5Zm4sGc5MYNCJYsosBa/0/kox+ZaT8U+GBzGTg2Ie/A5C9dapA/zEBwAJiiLsaHc/AK8Dj8upMCRgvSNFqSaSZ+KH/YBc2Ej6a2runqjc6jgMj8cLXDludQXUqQ0tk1Yf0iXDjLAQ4L26ei+tluNKIrQCYH8SwmGFvPLwsXtc1exkEB9xVMls5I7M1uCAKNj3ITmeObI2vXen/O7SgiQoLxGh2mJuURzCpOE6+Y+iIyJ6Fx4GZ9yQUwigDyO4cP1gfQXaZrV613ZpYwvBNCHD3Otv7kqffuRUrWovuzcu1BxolWqJnSPBzJECwcpeeEWw1t1rlVZiXcjgXHdjU4K5R4Qw56VHyviu2adZtnmgJDmfxVsDQyvz09NVuTyOJ/MHHPlga8wHUjETVyCxKPf9OEO2m0vWmJ1Ae4Bpj3SukuiugmiqXptxYxIXPZie9vNXcDNNVHGvLAe2GFSRygwzLP1SgmwIJe4so60eQ8iOS/X6AaVZ78oO9wr7Ogr3LM4Dx1xDQbkajND/G5fjXuJfly8Op9TOfEWwMMXsBoi+NlL3KFG3uerd29Xt7zQywOMSzV4pikk6InCBvazevBpefOeUm/EPPYF+tl6q/6cEwrqgeevYFZshMqN2qQU8sfntg/DeBsBh37C8VKhC1j6LACMzXH13FmmYiBqqW2D91J0SDDKC9WoGKLRel+6fKhDXHlN0D9W5ksPaKZnNIyiy+EwUb/+l+zsv2NqlZmCk/NqaZDB/+GUG5ZXvwB/NPmIg4y0srLrG7Dh5usTOSm/ZDapLthZeonn6Ioqr+hLILqFTrcUEOpc7nCUTG4EQol0mwm5MiDhkO+SH6Dx9VdyJH0Rjo7LKxFb4WqfP3/kcPEH8aY6Mo3C2K/WqAR
 tdjJkYVE
 r36SHMtRFL+ieR4LrAjL56bTkEvCjz/2gusfUP5MF7W02WQQDovR76h6MBRVC0wqJS0il5rTGE2/94jHCOl0/WH4k3mXMQE9K3kZ6I6CfSBO3juQhk5DbTwtftBQeGeqgDlXjR9mnc+mJH8GjjTDUoJruJHPqqK2ZY90UofIwPTHwhGSv9lkO3ZO39W+aVF7Qy5Hfrt/txAHfJPi6HUzEVvctA1cB6KoFc290i9gBXRQ/RFZ9PFFZa3e6tmFXZGQEu2qtak1xTuTIPYxvd6vKmvX6vyiknw99XgxgFEpKfquCt7O2D4PNJ3+soxz6S6Kotla04Qilrt1hSv/mm83HxN7N/x9+zTNW3lHpYvgKFTb/Cje5sZo3DqUzVgBclH1IB67R+5zYQU2MNoi6A0oKDM1R9AZoQH9hWNU12UNp4cSN/EB7SrCIgNzDFNOmZFsDxH37
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> wrote:

> I'm probably missing some stuff here.  Let me know.

mmap()?  That usually tosses a spanner in somewhere.

David


