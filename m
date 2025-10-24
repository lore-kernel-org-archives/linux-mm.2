Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3816ACCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7298E00E2; Fri, 24 Oct 2025 13:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF268E00C9; Fri, 24 Oct 2025 13:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC678E00E2; Fri, 24 Oct 2025 13:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9A38E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:44:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13F0A49310
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:44:10 +0000 (UTC)
X-FDA: 84033731460.27.2D16EF7
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6ADADC0009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:44:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="r4M8rMa/";
	spf=pass (imf28.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761327848; a=rsa-sha256;
	cv=none;
	b=LANZy8jz9C5ZMcQjJqPrhqJkewTCtPNoKFlUkqQj3orF0uJmfiORHrvw0H5G+nULmx9vED
	z/w12dH4U2Mv+EiCAIn8C+9FswdspvmB8ijZeyBc7zHg4pO8CyUkGTjI6UuyfDtKVE5iZC
	7sKjDeRGL5agge3RVIoSJ+nT33A9YnU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="r4M8rMa/";
	spf=pass (imf28.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761327848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBvzLPA7qS0NNGTUVGyJaSQQ79eyzPTJm98CPlg56/8=;
	b=HX/nOujCH5wLx+MQp9meZvnZfY3CNxuUSmP813EZV0YQhP3uIu0h4Q4AmfwvuiWRRZNwpb
	NkGn4cesz/Y8kdq0uvaLYB1JnrQ+5A2vgeiU9YjpiZjUeW7uIg/J+u1adPBLFD4Co3rQ1p
	Akqwt3y53EZ6IdmghNQkDncDV4byTCk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1761327847;
	bh=oBvzLPA7qS0NNGTUVGyJaSQQ79eyzPTJm98CPlg56/8=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=r4M8rMa/xSgme1HbOwfTBgFhqkdZ922RMLZ2XiUJIgbljm5deCQ2Th8KD6J2nCihZ
	 XR1vMaiu0XtZ/9NMrg90xrIGIPQhS+K12pys3IIKMhpiIdSQAYrKdkoHRIvxg3xCbK
	 GHreh7zx7sdMtPS9UMi7WfItXnwQxkAxwWMOk1TE=
Received: by gentwo.org (Postfix, from userid 1003)
	id 27E52402BA; Fri, 24 Oct 2025 10:44:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 27331402B8;
	Fri, 24 Oct 2025 10:44:07 -0700 (PDT)
Date: Fri, 24 Oct 2025 10:44:07 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Petr Tesarik <ptesarik@suse.com>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slab: constify slab debug strings
In-Reply-To: <819095b921f6ae03bb54fd69ee4020e2a3aef675.1761324765.git.ptesarik@suse.com>
Message-ID: <bef91069-3435-6097-ec69-4d45cc707a81@gentwo.org>
References: <cover.1761324765.git.ptesarik@suse.com> <819095b921f6ae03bb54fd69ee4020e2a3aef675.1761324765.git.ptesarik@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: hub8dhsnhhbkbazm7phxzbuhp3e7cikc
X-Rspamd-Queue-Id: 6ADADC0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761327848-740014
X-HE-Meta: U2FsdGVkX182jfVfzpc8SsldRdSVZdO386M+WTnHsDZVrje1oAqMT3TUJUTu0wSFzOPbj2c0tQtOQzNg0b+8tg0AlY2tU5lc4Raes5GVlCPtbWnVi7jZ27YxRAfDOGKal+RJ9AkeHYJBPIbGhczIlh1oznApeNXvecT99vQ4hxbVqvNnwKwOQODrjeuaVvqa8LbFopUPmKcpyQT3WyH04jKjrj6cxsiIuckz+TfO0lLv9iJD/yeLRT6qJIusl99JRmsWvv3x50/xXPoWguqWdmBVNWsT5hKkdG6xs7PZFZ6hJKCHgAMmTfnxmqLlVZ+Vgn/2+UAX07dqXtfss5n8MaUSuuOzk1HWGNtJu+0ZIYVgUdzTf4UJzc+13lspUw8uKHYLaRi03/ZUoULrZ3xfmoLwtWDTG+kZjRuiTkK22+pB0RUpqEky4PxBW6qIQ4kYe5gpdLDnggnPDmOcrJUE1NVrF60t54bObkix2lBoL4sOx0SSc0G2d78U7xiEh5LC3Ud57RPJ20wm1XA28vfC9jcbPwOKcqqynPsF4UkJI/kKYDCIZpTXrfcvWYRbK3XHek1Kx2eb3yZ4PI3uMdnReUD2b/wgbX4dPEFp/E5HkODOLr2D0pOfwY/GdF9GYofFAMZWesWzjaT4QCXbkkFIwIvM/a5lSvhc7huIF3Rogpanb1Cg1oxxu9gc8yJuOn5JNcpJ/xiEVZHRJpX9mc91FOCwb3rMG8eBHDPb8EafixC9qC8MFgQWFpOfj9rACldv7z0oHU9FmnNT3WqaYAInNi3s5fgeOfoSITvsd+pTb7et9lES6mpZJ8HxoDwyEwoP+d1GNNhl3BSdiL9Qj/wHFHNKzUgWTpZ2hwi/1MtRMq5vh9QMOQNDFGp5KzBgrdn0oPF4500ZYR5PG37jEPDhOvzYX/VRA09AKoG3r6PpA/2A16m/ebDyFLMw4ycei8WJaIWkHxTsTpCeKYuEanH
 Hk0a/IvZ
 0iaGsI+Eih2Gz5yNxuAFy7bLHi9f0L1WBzycZV1jQYVD88V2G9sG98wiECDovE3Er4aOUMTlEd1yT5iWlzeOnNmmTZfGCDKR2UcM3GwV/ijvjThYI1KxdlhhFBSVMaMarNYxDQKSd4Arv1ofhABYMTciL2tXD9piHO1+FCNgftCZf6+4NMZ/fYz0sHpzq3S25/6rlXUA2eV0SNeXfdCa+z+LY24BrfU4L9lAl2EsXz6c+cMMY5fHuxWTlMAdo7Hy//kMBSwahZZ5WcdybkEbCFYq4q6/hME+1BzzZV0wLdzjJxfcZH7wYljceYAZ2ir8ido0geJMBCV4MLhhgPkZHod695A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Reviewed-by: Christoph Lameter <cl@gentwo.org>



