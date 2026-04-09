Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89538EA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46EE6B0005; Thu,  9 Apr 2026 08:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E446B0088; Thu,  9 Apr 2026 08:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34796B0096; Thu,  9 Apr 2026 08:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C15F86B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:30:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 801D914075D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:30:14 +0000 (UTC)
X-FDA: 84638949948.25.8F5C3F5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38E04180012
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:30:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X6dZYlP6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3TK8WTTE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X6dZYlP6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3TK8WTTE;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775737812; a=rsa-sha256;
	cv=none;
	b=8RU8utAiSMTWMwjN8ODbg4qjexXaTqZ84Q/7t+EF9hXmqSdviA36fZjdtCOKSPAjwV1ND1
	EgPvx8/Imyhl5iTwLZbyhYzub86M9H2OSNCgYPSWM5urRA7lxjvoASOl7i4Y6DzcJaEiT0
	MosbYkTry/I5s4Vs//MEX/oU3M02Rpc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775737812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+BclCMMJkegAVjxkS8iqk3jYq/9F9dXxMWASAliJHE=;
	b=Jj54hUPrq/Iln37UuNKhFBe2DN+FkacmtB6CuAlHO2UIhpjXH3vtkNYk5RYDp66xvu0GSl
	3KCRDEg/Clbj2aJHRiJQ/66KxrVazkhJAeIFENXOmXOmcnKTgSsqvt8vFnEmWbD76EyStE
	xMqqzWzdDkx+SFyZEbE/RbLrKNdDBf4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X6dZYlP6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3TK8WTTE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X6dZYlP6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3TK8WTTE;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7FE225BD91;
	Thu,  9 Apr 2026 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775737810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+BclCMMJkegAVjxkS8iqk3jYq/9F9dXxMWASAliJHE=;
	b=X6dZYlP6DDDRp6OregtEaw74ANiWrOsY7Bh3gbVhrJEJv+9U4OVvTHWccgNlk6CqSRSeRd
	gSNhhue2F/t2Js4OvDV73nZvn7Slyzl1yO+c81KA58+mMJsLDWLCHrrU+puQeKdtAuOzGe
	qdkbiq0Q/jXK90m19n7RAzkqtYqL4hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775737810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+BclCMMJkegAVjxkS8iqk3jYq/9F9dXxMWASAliJHE=;
	b=3TK8WTTERfRUanMAPa3HPrH8Y1KMBSnVdrAsAxfojf1Wx84+ONKCr6PmYuk6kGEOyx0vKI
	7DFZCXNtZNJqgEAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775737810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+BclCMMJkegAVjxkS8iqk3jYq/9F9dXxMWASAliJHE=;
	b=X6dZYlP6DDDRp6OregtEaw74ANiWrOsY7Bh3gbVhrJEJv+9U4OVvTHWccgNlk6CqSRSeRd
	gSNhhue2F/t2Js4OvDV73nZvn7Slyzl1yO+c81KA58+mMJsLDWLCHrrU+puQeKdtAuOzGe
	qdkbiq0Q/jXK90m19n7RAzkqtYqL4hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775737810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+BclCMMJkegAVjxkS8iqk3jYq/9F9dXxMWASAliJHE=;
	b=3TK8WTTERfRUanMAPa3HPrH8Y1KMBSnVdrAsAxfojf1Wx84+ONKCr6PmYuk6kGEOyx0vKI
	7DFZCXNtZNJqgEAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 744334A0B3;
	Thu,  9 Apr 2026 12:30:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kWMCGdGb12myBwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 09 Apr 2026 12:30:09 +0000
Date: Thu, 9 Apr 2026 13:30:07 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: harry@kernel.org, rppt@kernel.org, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, ljs@kernel.org, vbabka@kernel.org, jannh@google.com, 
	peterx@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	usama.arif@linux.dev
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <d4xigmgectqbv5q5dxsrlunea3ynexa4ym4nuxy2rokrawsqu6@yfhzm3hl5nya>
References: <20260409103345.15044-1-komlomal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409103345.15044-1-komlomal@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38E04180012
X-Stat-Signature: 5q7fmmspzcjicjgs8zuzjkhucj9j34si
X-HE-Tag: 1775737811-296646
X-HE-Meta: U2FsdGVkX1+JpySYqBK2IUxS09ICNXd526fb3Zr4zIuqzevujNPtxGsJGVMoUfJj5u1GEe03f3QRyBaDv82w4jSiSA5Ed+5YP4NL9uYp+15rImaXnmxO71eOjvefd2urUIBNxXLfuTz/R0eOr4REE5LOLlnJtVhIYCMM8X/m7QGt5qDePqKVdsmz3hkvPeWoL+6Bm6W5ShSHlNdFUPRCKfTyub0talrNYXSmEsq5hcvOIMMdbggDDB+OQHd/IZf9EChVIYWb8uxATnyhPKur9LcJiJNv4eOhnY5q1/Az9Uf+aCPw2eqVPy4L23H5Ifj0RF63gpMC+KdjtN/FvWU3ltFWgLdiKU/jAtL2BmktfTFR2YpoN/RzazShvHHxQ7ScfVcx96nMl1mHmMZbJiaGczDphEJ74apsHhRDbxn3X3YsIxQVx91CI0uqz/y3Cf1yLohnnr93rH1CCWRpIZuJ62FXhgUUZ9xbiAavbOjM1VzYED+91BUerhMohIV41zSQDUkUN7repqolMz/1lItKpMTdW0eW1ULSDIRpd1TX17aIwVf5PbK+tXMIxDDZD1jbt5lYfapZA2+WV+NulyRZ2smM/7t6XsJIRUXeI9nGKQ3+C3qD+cAUvQkuuh4T7cncZMi1XvVEiDfjjR89UAhgdkGLwew7YZ76FREpirhwYkZDOvpdS1Ikiphy8kzd7gljakWyAs3w6nNGpAbczk/tzGe6LFosR7bHxHYKkoKBB6exEVyRrKUAo6oOAr7Vlf4s4Iyg5SJYLBJuva496OTmZWGMF437IGTigFp1EcM/pzAe9RX5uiKOw1Kvf3ixYP2XjTO8iOIG4VsDu/U5mg3+0qBWriLuBmKlKMlr53G7jog+9uDx27wCOIeGrHJdWDRe9Pj96R+RWadEVN1eozub/k+dtzF4wqtfgSW9rZuqLxbWRz3fotNeA0ZkKvYW7lQ7aVFXzXv+HSOkFqsIrPX
 nd2iGt1I
 OBeCKk48MuVT9JvI8wufTaB1/CjCy3YI0jcYUfltbiBR+z+I4Rva1zi0dTQ22lJ6GR8TsiY1GzhgPAIP4gUlUgYsikpfhJxCw15lvJlhOg1A2TNYzkPcGq9UJvipZjpfaq8ROjoaLaDSZvv2TouAHAAT6tZU0hG8f1ZtcHDCbwoaQacmdO7mT/1B5HfHJ+jpic74Dukc2hjkxaAXV+2L80SkDOUua5pzs/dbIjhCUZYgwiq747GBAQHd2ZFgy/m87ZffWC0o/SJFwB4V0nwmuyQSAhksbEmzVt50BJYfaVdMf0tpiVBsgQvew8HjUgETyuZjxNTszqeXxN5uZ6sv1MpCT4D3fG0jPMcW0VdfMBEmrvi/NtBbvkaLp9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:33:45PM +0300, Denis M. Karpov wrote:
> The current implementation of validate_range() in fs/userfaultfd.c
> performs a hard check against mmap_min_addr. This is redundant because
> UFFDIO_REGISTER operates on memory ranges that must already be backed
> by a VMA.
> 
> Enforcing mmap_min_addr or capability checks again in userfaultfd is
> unnecessary and prevents applications like binary compilers from
> using UFFD for valid memory regions mapped by application.
> 
> Remove the redundant check for mmap_min_addr.
> 
> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

This looks relatively safe. However, I'm not sure if we want this in stable.
This has been broken for 11 years now, with no complaints.

-- 
Pedro

