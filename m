Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E28FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98AD6B008A; Thu, 30 Apr 2026 12:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70916B008C; Thu, 30 Apr 2026 12:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE056B0092; Thu, 30 Apr 2026 12:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3236B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:04:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41A52A6205
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:01:14 +0000 (UTC)
X-FDA: 84715686468.09.058821E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5FF5B12000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:01:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rgPcQYYK;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777564872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbTtypHrdpYJsRb7AQWPtav8p83ogCl9TMFwHWejmtY=;
	b=xubLlJg/y1WTz4zJugbUpsYOlx85W549cADLLYn/yoe1UUlsVmox0LvrmurMhAm2BKsJRw
	EOb4l7Tfvp7uv/K2SUVAQsbvVaftOo6gK3LVFqMj5ig2ovCFJKTyJWVlWgRu7NbkOdgGNU
	ywZOvWd3DpFDPMYYqYlEjC0RRgvvHK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777564872; a=rsa-sha256;
	cv=none;
	b=STQ1ZiCXg9Z1SCK1uoaqRVT8Bw64QIwDYOX5qNmroaZfXTrwEl5u4buwf865ithgyIkmdh
	uQofj5N049S8hSd32Z9IuQLa9QWfA9902cPtzjrDnPNaLVyXUHSSk1V0SzMCiUkNXxa6x+
	kx268cNyBxYQNKspN1QEXXNBeIYPX9g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rgPcQYYK;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 400F840824;
	Thu, 30 Apr 2026 16:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68F2C2BCB3;
	Thu, 30 Apr 2026 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777564871;
	bh=aO+uksvBr1PujI9uDvQOK6XwOmXIwiaz0h3v8VeWKK8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rgPcQYYK8jMIwKvpuB+ZNSANPcUqohaw+Kwe1YDD25iZcluEdv5Pty5QZV43agANS
	 ro10QqZf1hU/fv0mQqyA6Fq7lpgMh9kMgmzZ9iEu6KdDiGWuWcT0Gw3vFxZbHEQn6o
	 n1YNJBaelpAcaS0VlI43saTi6ripOkXU2tHRBFco=
Date: Thu, 30 Apr 2026 09:01:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, Jan Kara
 <jack@suse.cz>, Peter Xu <peterx@redhat.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
Message-Id: <20260430090110.f3ed78910ea7cface7d73199@linux-foundation.org>
In-Reply-To: <20260430113512.115938-1-rppt@kernel.org>
References: <20260430113512.115938-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5FF5B12000B
X-Stat-Signature: 5wo3soqtcz9c69qmck6ryk3d14h8d8gh
X-Rspam-User: 
X-HE-Tag: 1777564872-376625
X-HE-Meta: U2FsdGVkX19vmClR13zwBRAcYhRtKsdOHPa9p1jVuayGZu4B0gDKK0ALgfApXrW/GbmjjMuidIRg0wFkYk6FsHL0/R2qX6d8JEKPqYajRL/rcKJvWrsWV7nYOWkJipU9hY0k6OAzqqhpPP+79FtvYmn17inaWbNQ6Bo1EV3PRrYmIk2PX+ZiY+VSeW8xtSm7ikaY23XNrAumI0a5ZTHxOLFqNJndMIOG+r3+UA39IeP7fefLCe90TGE5l6n3j2Wvu0QpcP1S4EfhAc6HOE1+2nP3kQ5QErEpcgSFoKf+5RPZDp84UJhjJljyxp97kZbkQfReQjo9hF7WjRXR3p4bdB9c1J9cnobY3DyJgAEGpSvxmfD5P6da+a3ztbZkaSlS6jxXuaUltg2Ool9O+eoUMLVMsXPjMa8tCIyGzAd0J9qO8p+cKTgCM2IynMyjGPs6mh0EYAKZJzjKWPbC6N+hTjv8IhwSZu8i5tQEKgApWbdROJKYAQBYAwR5TEIOGnBCGhWm1Z7IeQvXREroGLr8dt+nnN4eVUKlHgOHFlc00Zoyjo2V0Mq0Z4J78IpVjkszd6rlLWGzaGAuGXk1ptep44Lj22KlaD71sZNLx4IenIyyLTc8GgK6BGOYaK5ZL5YQjtKjxGd4qz8rF9MAgPJP18yRe8I9ekSjmjkABfyo+dMjcG0M2iVE6ZGsiHcuTtc0jd81RtoJiIkt0hmzLMA4lIWzUuXDxgDeUhfH2ffjY3CWAG5gw8FUx9UdrOugTlq/dvUsVANPVqBKqMu2/i4RJ3Zx8Ru6lIIbzrt0P+pAVwktWbLgstX9mrR08+nU8NIH11TlUjguDBZxcsbR6ABQJoD7uERyJ1bOUp+m5lMlgJOAwc/TqGvblh2+hmHl3ZSnaM/TN8nOcmgRI7xe1wy9tPQOqpbCtQAkn4TXSxcQWGg3rLmssRye3I+g/f8cxral0+rlYTr7r3gZISMIMNF
 3xfNBgyZ
 W3KNDjPcsP7QFI+tvmU9j5SzZWH0PSy8Shq+s1nRiPipulTkC3xgb2Q1fHB2hM27kVz95kxAO9+/3886f60ERLP+yir5C+e1TPMk4FjV/+I0IagKYSMaOXJTCtpkvwuP3t9KenPLivxFrqb9/2vSvv7i95Hv2nTY2poqBdxJJgbuEoWIPIdh+queWcv0AbtmSVWBihV7PUOdJSK+7lgb4nTSLDPVNtI8zmJvfysgFGdCjto1QRBk5HytNVIU46oy7MuGE5DkRcWl8UU7rkOvghLJT+ulNuuA5EscLwvXnCeQRj8a6S72rmKlBEzcliVm4qyBjoHcqOyvG3sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 14:35:10 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
> functions used only inside mm/userfaultfd.c static.

It's kinda scary how often Sashiko finds existing issues just because
we made it look.

	https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org

Do either of these look legit?  If so, it would be better to fix them
before doing the code movement, for backporting ease.

