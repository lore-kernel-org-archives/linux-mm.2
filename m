Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A2BCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D0E8E00B6; Tue, 26 Aug 2025 03:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245228E00A8; Tue, 26 Aug 2025 03:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15AAE8E00B6; Tue, 26 Aug 2025 03:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 016D18E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:22:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B552E139780
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:22:09 +0000 (UTC)
X-FDA: 83818064778.01.4B981DC
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf08.hostedemail.com (Postfix) with ESMTP id 35C09160004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:22:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=JjmObyhP;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf08.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192928; a=rsa-sha256;
	cv=none;
	b=zxeJjmn8tHlKKVRR+JysnJVcZBuE55xAZ+VoiCKZKWUFigJH7WbaUm1Lia0kkX1DrMccVq
	GLKXw4FZ4dGFg4o78BvHCO0hAwxP+K/485MbUvJnMh1Yf4bRTfu6HhVh+U2hcuA8Jx1Csu
	g+4Qll5KV7htg+u2j09/XkBnrsjKOLE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=JjmObyhP;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf08.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veJtPEJ9bn56lBUtIQcGh3y1q+MNYjksl24KT7dK3Es=;
	b=GYLb4orTKXJGcPXTSZVGodBeqQ5yw03aunmbO7bGoJgZjb8MDrTlRJ9y/5jA07woR6EYZu
	8T5Hub+unLj+f/R/y88Pn4Xjy44pYc/cl8ADse/akWSFSITAicuXgRnV9XsEEhfZq0tpWk
	D0TML2PTTAH6CZJ1RzoXWXRjz/Yvpr8=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 0709740AE7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1756192926; bh=veJtPEJ9bn56lBUtIQcGh3y1q+MNYjksl24KT7dK3Es=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JjmObyhP4Lb0+RL6pxoFBnUSA535OOZOcSswlP+P2+Rlxcur4RwDbbgMTKcp/LObl
	 h/T6FbF0rz0iMWlpqxFycxdJzlP2FCUU+Z82Skqjco6nM2mZCHX2E3yC/+V0nL4K+n
	 UDEV/oN1wql6lL5kXt3afkJ0+gQfl1Qp4/e4jvJ5e+1hPIj1jb7wjoLczbO+HwRzgg
	 iOeS6VkMOnbjT+/c6EtSuOBdtwaY4OYMdp5SNrkML1YMyrkgWBLeJgTvEOw3wvm18B
	 kldGgFK9IyTFep3dQES83dx0+nWDIVf/xDzl4niA34sgF6tTxkf8WRbYcv5l3ca0OV
	 6bA3r989KEGow==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 0709740AE7;
	Tue, 26 Aug 2025 07:22:05 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Harry Yoo <harry.yoo@oracle.com>, Andrew Morton
 <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, "Liam
 R . Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, Kees
 Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Rik van Riel
 <riel@surriel.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH V1 1/2] docs/mm: explain when and why rmap locks need to
 be taken during mremap()
In-Reply-To: <20250826065848.346066-1-harry.yoo@oracle.com>
References: <20250826065848.346066-1-harry.yoo@oracle.com>
Date: Tue, 26 Aug 2025 01:22:03 -0600
Message-ID: <87v7mabl9g.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 35C09160004
X-Stat-Signature: 44gmd5ayr1eopznfxctn5hy3mfgzttx4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756192927-970928
X-HE-Meta: U2FsdGVkX1/zBnLJkUjl6ea/KY3r7O/QBgaLIB5lK9yZaPF1mcUmanN37B+ub/22QLjBI5S4r53RD+cSAKLkVcw5Og9DSVNchvuhf7Of0ief7XT7ezznH8JSeL3x36zPfZ54j5wBR3mPWZ0jtuqMSWzXdN0xSFu4qcE9Dxml2TK52iSCZfR5LFRmTqWQJG5x81MhNDaK6xY6+bBoDE9K436C+2PtdVUhOpv9LGTEznc5Dr/iToPLuIReL+sopYKHEBWYgOZJ3M6dq3JxEmmZ/cduRgIrqfwyYjAKnnuHX0jam7zupIwuBd0XyPmVlpc11qYnQArBhRfyS3nEqKNK2IW9glGX+yM8jx46+VdocyapqwTh1r63IwhTOd43OEb7AFnVEw426/14uS0t+0atV0szICUH3Z2D/qcSOn/N4NW8I9J0P0dyh6almoMJIfdKC/wBhzZbapTjKYXEPqxw/O+p7SlkBGUL7N6dTDrITy3PMr0YpFnXK4XnLl75HO1V1UXWTgry852lrp7SQqGmDzmEgdFSz0kBpKpn5/tn91/+Gwqts+5AhC9QMT+YISMakGM/8TW4lvARzTsjsnM40PMARvrAFKsbJJ1WIgeEYK6hYcgaGC2o/jg3kW7k4mXPbPEWEp+lr55tucFDxd12SS1yrhP43ButUTfRjV2zV2fpS0tvVIlBYdzgkuFglvQpvneubzfWxdHl2XDrtlY7cIfQi61ZgZ5Ypo0zY3S3Oa6ATfWsmGXhnK9om27sBnbVlRcj242jnKJdwrs1zIJhEAcEEmEknI1T5afq+cwHO/ZvCnow+6Ef+JFZzdF39/QGzFobxXEjM7MJIiliR6kAplG18G2P4Wq7uh/vAAGAjFniX8xeV4Y5C8N7ln88GqIduVNyYf5tcLQUm+ji4loc9Nqj3vsJ/uoysxPV3UV2Togxs6Y+UsoY116jaNkOF0ZGtesUQOTLLPV3CAPijwx
 LgjoKM7c
 WlOCTEbENOTXaMOq6oJsyYXhcf9tvZ68vYi+LUmWKw0g/eC/FOlEIAw9efg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry Yoo <harry.yoo@oracle.com> writes:

> While move_ptes() has a comment explaining why rmap locks are needed,
> Documentation/mm/process_addrs.rst does not. Without being aware of that
> comment, I spent hours figuring out how things could go wrong and why,
> in some cases, rmap locks can be safely skipped.
>
> Add a more comprehensive explanation to the documentation to save time
> for others.
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  Documentation/mm/process_addrs.rst | 32 ++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index be49e2a269e4..ee7c0dba339e 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -744,6 +744,38 @@ You can observe this in the :c:func:`!mremap` implementation in the functions
>  :c:func:`!take_rmap_locks` and :c:func:`!drop_rmap_locks` which perform the rmap
>  side of lock acquisition, invoked ultimately by :c:func:`!move_page_tables`.
>  
> +.. note:: If :c:func:`!mremap()` -> :c:func:`!move_ptes()` does not take rmap
> +          locks, :c:func:`!rmap_walk()` may miss a pte for the folio.
> +
> +          The problematic sequence is as follows:

Please don't use :c:func: - just write function() and all the right
things will happen.  (For extra credit, fix the existing usages :)

Thanks,

jon

