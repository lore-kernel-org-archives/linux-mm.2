Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A4DCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 04:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28CD8E00BF; Tue, 12 Aug 2025 00:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00258E00BE; Tue, 12 Aug 2025 00:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D358E00BF; Tue, 12 Aug 2025 00:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D07E78E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:02:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0EACC011C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:02:02 +0000 (UTC)
X-FDA: 83766757284.19.8093A47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D065A1C0012
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:02:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cvTLaKBE;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754971321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA2ENav66HRcQXszwFcZOIQle5Wu9b9unZw4hwY63HA=;
	b=m/Nda4jviOQc1dhZ5vSFmzHfrkW1Aq5oqly1WyYYnwxIUIRYkGyonfF2so5MaK2/zzvftW
	i9jy6wmiuTepprMvvr5WAXIwhbqTKqWpJ2DMJyYuyBudZoZDdZd61yKD4x514NkuDSV4G8
	N9siackAZIxvlI1XplN83UJaI+/s568=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754971321; a=rsa-sha256;
	cv=none;
	b=5OY1jgFfzWNGT65BMAQv0L7Wrn7k/eFieySBi8uBc1YIMMjKRrAK9p7FMtXxwT7bEVwSuz
	YCuBq9SssVA2H/vIddLbHx1dmTglf+CzFGybEr4l6dHbQHDzgyqfvFKt51SSdIUQelO4KN
	Wss0vKXm2YPBL5FOYqASuRxroD0aMFg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cvTLaKBE;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B1F143821;
	Tue, 12 Aug 2025 04:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BA1C4CEF0;
	Tue, 12 Aug 2025 04:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754971319;
	bh=PFzKbM+2fBf16ElXHAHAbCarcxJp3vqRWsPHanph7lk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cvTLaKBEBDVURD8sSrIpI1InFCjf5XX57tNgRWBiBq81fUfav7SU1vBYoUYYP0Eov
	 KK2mVLyQ0yPBOehKRbH+IKdeUxVocyl0ARLdMjlBVSTy9cWr3NpqW+T2Atvjz5/OXO
	 s+1sYraF9XHzEzw4esI25jmz4tsla1ihoMIGKKjM=
Date: Mon, 11 Aug 2025 21:01:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.17 0/3] mm/mremap: allow multi-VMA move for huge
 folio, find ineligible earlier
Message-Id: <20250811210158.3241454a858582a7600e62e6@linux-foundation.org>
In-Reply-To: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D065A1C0012
X-Stat-Signature: cyzm783fpoy7yfhifqrctqwefyj85ic7
X-HE-Tag: 1754971320-460754
X-HE-Meta: U2FsdGVkX19sIoSJOcT3Nogg/6EMv+4FjdyBXlDRw+4U/4Jg4t14a9st9/kJ3HAm/gzIWZvrt5eI2aQ9rxAFmv1/arINfmMAJu6Ock1pUfI5USjCR1kgET8tgIJV1yIPX8VilGvSf7+k7VPpedT+FO2eStw/renc5CDBmi1rAAOwk4eRK1tLhkmE9dKELA0t4GZ105dGeIra1cvagtI7ne5lSN1+b+PBxntkugDo69GuakzI0ZcFYxA9sJeFEZoOzRUpG+6W8Hn00YdwwyO1UvPedjPDVnDfRPveFJAhOjROFmsIahPZE0m4ZcKqfb74FQLDvRCZg9xME1WkdQw/NnWUh5uOPn/K279Pf63ER2zA5JO0x/yf2DulQsPbC5eg19ijrjxhE5IQ9LgK9GYWRpwcVIpTH0E2z59urwcq5f0CgLS4KuhNYbKpbZTpkTjwO+GEBKy3+UrF4KPzVmopia32TZmTAsmdkPNsLn7OG35cJSaHD5bUwWmZ6TAyjPXc/dneXxK19h5KR0JgIYI/eVmKrelN6P6a95LWmNPhGaTUI1rcvVt5OaigiwsgUvbr5GdDGazUjGew/aMvCxWhlXwkztVg2b/mSpkwugGp11BPfL4rs2zWQ3KXFXFG/JkBnid86ORNKMJQ9DP4Mm+hra+2URFRYpJTLkvKXXMvKtbyh/6Y4tWoJHYVWlLsDLZK1TzYPiu60e5uvmSV3EK9h1HMiZkVUP8Tf60QWpWhdByQQP755XgSRCDtqMKYaruSF7//y1I2tFF9Unz9pvj0FkkRNwbMA/bevb20H2vpwVdiXjk+Bz5ckqudB2vH9S3LKwO3c2mZGZ+pScnzA7aEyRcQ/znVTJPWAC326Z6WWYit3927d+zLQ9DBaXozeQYtw+iau3MX0x8k5pH61QmntVOPDwr74+hwvE3pR+gtlY5c8Lz/CT9xx9uf5/nQTe2/bIs/MeyXM91PyGyKdpS
 1cY+/uAZ
 9d4ArzFOL0Za/io453UwYhyuJQVjDyXKbA4lgS4isXAvpQvQI/WOnRotPv6Sxd+SIHJLdr3MUXYs1pV055B+M9mrdIqKYvvktQnjId4VYCCw44FOYBVqEjyc9FIRUWs2Wg5dKbCWFll0KNqWN4yJFrxfsyFZ51kX4koAvRAV9simbUCG2KtrI8bFPeBsFQYMlSZCsOgKSLhCTnfzi2DMr5zBLEHEG1MobbAHzp0LS2+ZX/THvRvkYqo1CUyU7/JLKcMRTApp6aWCambgPCgNLSMZNoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  3 Aug 2025 12:11:20 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Subject: [PATCH 6.17 0/3] mm/mremap: allow multi-VMA move for huge folio, find ineligible earlier

I missed this series until just now, because the Subject: innovation
fooled me.

My pattern recognizer saw "[PATCH 6.17 ..." and said "that's an LTS
patch".  Because that's precisely what they do.  By the million.

I can't say I find this change valuable, really.

Now wondering which other patches I missed.

