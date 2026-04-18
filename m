Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB84F99C7D
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F305A6B01F0; Sat, 18 Apr 2026 05:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEBE6B01F1; Sat, 18 Apr 2026 05:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4C26B01F2; Sat, 18 Apr 2026 05:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC8716B01F0
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:35:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65F2D58E1A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:35:46 +0000 (UTC)
X-FDA: 84671169492.19.BE03EC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CEAA5100014
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:35:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wu0KE3OJ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776504944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnNNPJsbLC3odrTyoySEhdAf76vObTQcf1eB9hxRSrM=;
	b=SX7YeAd1DMf5XAif76ZsnGuA6ZVTQxKW3gdLRehX4HIbGsQRM2Dq0rB/ZYMZrBHhUlMxIJ
	MS1tyI0ARsBhSzDbTFd+YMGg+Sm9+rQNIMfLiH8ihEK3ueCqKrDy6FN6KjqtiA6f8TT7Uk
	MOXHZ9/eAyo3bsFx1mdvqtv1qgnlP54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776504944; a=rsa-sha256;
	cv=none;
	b=7OAxsZT1nOOxkI4E9QBoFgWOaPz9V6WODx5IVY873XPbNp+0wPNx4ON+1MEo+GP/7CxKS6
	zwCVdpv6anlLNYQMDqfrYyiBPvG3pBQ+pP85BIyKBxaY3b7PPg8WSHeBMS1RV3K7kVZ30a
	8h6aUw0Q6nbgtUC26MY6j+Gp2+RZHu4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wu0KE3OJ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F27A60138;
	Sat, 18 Apr 2026 09:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6419C19424;
	Sat, 18 Apr 2026 09:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776504943;
	bh=WnNNPJsbLC3odrTyoySEhdAf76vObTQcf1eB9hxRSrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wu0KE3OJzoD85Zv4R5AGk2I5OzYsyw5GCIBbxHlhqAfNs0dyg0KdEN3sIJSw5Jtbd
	 MoHdzjwtVup+ZJMVaw0CYqTdUIyz8qL44zsR5Bfqv53bzuRlKkAH31thrITWTkvZ9Y
	 9YZVCtssSVnf3cOekz7AtYTagvOOVoUZ+1aowVv0qdQ+UUM6YOcM2xtA+OoYi2QEpR
	 TnvhF4iZUgIihc3HFC1C9XEFw/kH/Rnw8kNMfChglPecjfFwHEx1BYmCopRZ2HDjQB
	 Xi6nGWjdb+AmJ2Yz2lIBUtIw6kcSSEhjcZxY2VNTOERfj+QeKtJzq7fmVzgU6Wjzek
	 MU7BCugwA2wCA==
Date: Sat, 18 Apr 2026 10:35:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Message-ID: <aeNP7mtx878gynXS@lucifer>
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
X-Stat-Signature: uoxwwg6bjribogifyyddcjxjosibkkfc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CEAA5100014
X-Rspam-User: 
X-HE-Tag: 1776504944-393370
X-HE-Meta: U2FsdGVkX18azu8edmmvy6O54JlSJ1oA356uNxj1qib2DEwqyLBNQolWr7YJLmauxuQOHJctsmB+XFInmkfI6s1kxFc6kifzrFTXkeTBiONB1CQaacPU15mJmQGn0NupVbqdrErDHO0IM/wU9ud6NGV4oS6Y37So7oj49Zo5smIgo4aKv+roZz4MLZZ6Dyw0uKhY5h9YEMYknbZVyF4RetxLqRKCJTtvet7SIRfxpo0qccb5b5Y1jJtOlZkz2Z8A7wett08KVGOUJd8XJQg8qofrwLXKBd2oSDDZmSYztsto+irm8FXSQYfl5xyek/xQw6+2CoA3c0+ucCeTgZ09phYwqRuPXJp38LfYDtZEFOL4QRkyJ01brWikL9t9JAp5jeRpsGsNBJm9nulMtVZxUmJ2uN9BIderdsCuQ57RDuFV2oEHog+RqfTWrzLExYF2nzpCG5gJx0IcUoC5lUP/lllaI8ffQKzQTLzUdECHLksi7jCkv19AMlZzQXHhjZk2sWT9qHeOYQvLKYOTN7Rixf80pKNWHAvW/RYcJBPVV4x0q4tT6rMQrNh9ADK7QopV5fNEd1zD1J6g3bWNsp+7x2ZAsjk9N5IX7565+aNvRXS6EgVc6lf2XEY3hPwNv8lGKp1LUH0xxf/rh3wPMpSOFRmKSy+g8zGcSrrUv+kwMUFJ+UTw236grGHFY6fcNUGjvUH2i5LUHZBoJupVNxUduNfIZpushIRruAKvguBUfY9A3vQ0NBIbvz57sPE5bzGJoe8+EAXOPSJrN3+eN6izAHwOpLjGMKtJl4rCerzV8HeVFeObPp0rGvKB/jH7G6fheROTNucH78YE1RLUnx50M7j9t9Ksk+Uquw4kIjABhKwESxelQIY92YT7rTYZAPN/f//DrrNBjHad2sIn/Jg9Vp/NfBJ211htfNSDDctaAezn0zGjernKevyvG1H98yEUJVpHuc2nLmk5y/rAYnU
 EGEapFYS
 dH6Lg6APpBKGHoLiz3UxebKkTKhnJHJb6q/yg5LWSFCca0wQ2JabqaiqYLEnR5C65RnuJnvxz0ui6CiN26K7NdQY5lW3SjnjRua9XLmNAer6E/fp5QGAsjtOq2elclW9qdF8gnjDp9JU8UODLTqHuykIqYdBQxL1XGoAveLUVxgtfK8r/Zt1bn0tlrNAIBZmmXw6P/wFQcRwQjUx5aEjgVveJM2JdhXXxA2GCtFpzc5fxIKmTFnItzjK3YzgliemI0FlqzPaZRyI34d6c9FLAfBUzeJnVjkIitzxfyNUPDCBjhcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wrote:
> Maybe there was a scenario where we could have lost vma->anon_vma during
> a merge, resulting in a swapped page in an anon_vma.

Unless there's a bug (and correct me if I'm misinterpreting), VMA merge requires
vma->anon_vma to either be equal for merged adjacent VMAs, or one or the other
VMA to have NULL vma->anon_vma, in which case we set vma->anon_vma in the merged
VMA.

Thanks, Lorenzo

