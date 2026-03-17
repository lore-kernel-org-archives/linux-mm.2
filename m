Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652A2FF6E82
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 21:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78C56B008C; Tue, 17 Mar 2026 17:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A396B0092; Tue, 17 Mar 2026 17:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FA76B0093; Tue, 17 Mar 2026 17:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A57C96B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:11:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CE478B522
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:11:55 +0000 (UTC)
X-FDA: 84556802190.14.79767F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 90D37180004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:11:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Inguey38;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773781913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDK+NxF2y4ZHMO/TQgf/a1Au46/SFTY7rnw6lCrjC0Q=;
	b=mnCXi7NwFAytxj/vU+6XSrC3ZM5a3LNIq2A45T6lXBSpAdk0Vqe5k9f99metlX66j4p0vJ
	z8yB7kK6K6GbsDEIHYAbXF7gRjMWiswjm9G2TYbDjm08XjddSndFxhauMQHmvp1+N3xv0U
	87C/eXGlUgGZhq+V8U6qhD1EmB4NG7c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Inguey38;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773781913; a=rsa-sha256;
	cv=none;
	b=S85HQiVvIoVD8x99fl8X1sOeA9hwuT/1Ej16fqmiWSs0HBxTPCkfTgVVtd8Zm+FBm1TDdl
	PfHIBgeBGPFWFC06BUZYFDU7I11ONX99TnmmMWpgpqNh2eckF87BTxAyAah4f8+Uz4GHnq
	tQsWjD/xCKogn5iM/VUvO7h4CeF5Rqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9503143B16;
	Tue, 17 Mar 2026 21:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308C6C4CEF7;
	Tue, 17 Mar 2026 21:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773781912;
	bh=GDK+NxF2y4ZHMO/TQgf/a1Au46/SFTY7rnw6lCrjC0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Inguey38LrpVRzhYYvdzHK763I87K573fSVaZx7wHzEs2YYTFr60BganO6RmTRWT0
	 vzdV04rNqPQkfDPaVXk4UR+FeJBL6d7g7tM9e+bl+Rz3iJvV6C/xxACSI7ZOkCKVvX
	 TpDrzV8P+v+/+gmJxYXtZoduHST8Q+XwpRgR2LdA=
Date: Tue, 17 Mar 2026 14:11:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shivamkalra98@zohomail.in
Cc: Shivam Kalra via B4 Relay
 <devnull+shivamkalra98.zohomail.in@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alice
 Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v5 0/3] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-Id: <20260317141151.6ef2a2bedb74fcaf2883c0ed@linux-foundation.org>
In-Reply-To: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90D37180004
X-Rspamd-Server: rspam07
X-Stat-Signature: n8q5n65ih3u1nq1ys9qh44yjr84kcu8e
X-Rspam-User: 
X-HE-Tag: 1773781913-379843
X-HE-Meta: U2FsdGVkX19XSdNVIa95lIRkQg3CZ2erNd/2GGInKfx6Lo2F0lVdT3zf2PXc2nsokekJ4UPR2ldOWQ4Yg4QKlvu6f/YNi7+T/eLOgvxLD0g6ve7W2X72AOFOHZiBHP+0eIc5x43lz9QG1NqLsGDFhsTn3/h1KEeA6f7IYWrQdLlbuqy8E027whwLnSJjNEwo5M/MQoRbW2jnJNcRqn+lWW/OjwaMjbMdUvXcO8zXo+TldxYesxyE+nSpwico7kLRPq/YZt+n8QL35pc79jOWC4V78zHCfkriU95wSkpaw6v0oCPJD48KO7FqaPv3H6/Pzr/6ue/aCHsgxoP5epPkVW7PF8d9mbGTygthLgnh+vjq0/ct6poo2rhui0lVvsl+KvJagmR3IR15JZC1SgvxWWnA1ldSMsEskidd75jjbmcGewqMpzj7CCn3SVKe6A8+Q08XaJEhGrU9zrEJLi9npWlbCFecL7xUyLJbegKMUIThW4TJV/SOU/njSt5iMCx1tCM2HUSx+gcRSB0AMLioESjxwV6xNR5iscSDmtJcdTBTg7VgKwaT72UYblbxFLd0j/vSg3ScS6UQMscTch80D6j8qJxkpL1Op3mjGQ4THWXlBJLaSUtaYfaqX3MsZqUFBETz6E6WtFWVOhzKAi/YbxEOKrLRQ0YTznjf4te6yjquBO6OggDtB9CWjC45wOJRPGDsQsGWa0o22v5TVHHAatkIlopYFPhanO9qEfSY4xlcKM6XsrhnDJfar5rWxz/owcgYz1SwxidlBwDGhSHQFIEoTX4piOewbtFhjrIFXeIThBJRLz60Ut+hQoaNQtL31zXgOW15aJWF/w9I+olyZIdn8YoxAgPpW7jE+xk6BQDEsLQnTBIeeTGBYzA4yhXLT5u0FDJJlkJQm4ZuAfPdUehiWX//XuSixGx8gKU3LaigrBFpC7+hA1kFcTbDx/a/07fsn5Cw9QjUxeAXW53
 JAimeZTk
 BXG284Vw2mU87HT9B95IWISFbDefbQSsbZDWdmRSt34bi8XtZWdWK4siDmpljNuSGKxCNqF555qgl2JhqxNvVfRDvdDbhd6yxyRPq8cXZHot0bHs9SRHqx26nXeIBE2/HbC5RNSuVAG1bZb4d3BQh17Btgqyx7MdlYmS5Zgx56Ua0xVl8vGq6BJTVUrMpsVV/2iAJi0yRsJA9GnJljq1yZydTQKt4hE5gc1jWdtOy7ZXdnsosCzFPzXz7qw0JdcAFB4V008TeTmGkB9vDgn5ufUFGRNe2dN7YvtdQ9ERarNEW41mlu8ai+zFrDNJpifYule2oeU1zxnuLY9g9KvL2AM7KcU3KjEBdY6L04sLUOqt/QRzAMqs8ZzAJOIX98VZkTIq6g3f8Y73cUoC6vJzdLSN4fOQ0dUYedk38KYsgRNcGqH4pOSXYx0Lz/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 13:47:32 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:

> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.

Lots of questions have been posed by AI review:

https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in

