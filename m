Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B76606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=msyIHhIt
Received: by kanga.kvack.org (Postfix)
	id 15CD26B02CE; Thu, 22 Oct 2026 06:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10ED26B02CF; Thu, 22 Oct 2026 06:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EE16B02D0; Thu, 22 Oct 2026 06:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBD6B6B02CE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:27:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E45D807C8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:27:36 +0000 (UTC)
X-FDA: 85349885712.12.D8C9ED5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B72B6180008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:27:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msyIHhIt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792664854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i/bEbxuGcfxHFgBF33/3ognHBBD4uli9jC93OptmuQ=;
	b=4IpNnjDovVHBb3VzJJ0/WS3a1XlJZcITLmBW+IudbWXCbjhnuY9CT+DEf+NUHaW0R9Gr1V
	62RN5QlAu4m5OnKZW+WxwCIgQIg3QlFhvOeVK98FwWpeEjjAt0BBu6PGg0zTHVxFfT0KVH
	FArEx9o5vQDYZHi96ufohmiCufNyWTY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msyIHhIt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792664854;
	b=5cAOfoly4J296UFUbB+Sdh068MgGtkeO3+l3TXLPKqQ2nQVgZb/be1tXL6Ii1sESEjajrM
	y8DZMaiiQmr2tavbowRe1AzZMK5DcH9hJRbRODyYRHePdO2l+YBZAYk9Hy02759USKMEg9
	/3AUEzBkrj7HRM9xJaDbUftQG74sCFU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EAF760210;
	Thu, 22 Oct 2026 10:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE27D1F000C2;
	Thu, 22 Oct 2026 10:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792664854;
	bh=5i/bEbxuGcfxHFgBF33/3ognHBBD4uli9jC93OptmuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=msyIHhItxYKTq5jN2FoTYszCQmBbsyMEdqNkkA32J/6maH5H4ZVWFZHljKJHN60uv
	 poiaB6oeeUhom1gG63UWLiobxbTQJb1J2RhsigElHV+uyio8Prca260ioYuHGqhlke
	 ucHRvG1j50mu7u72qrDcWfTG3+OY7O6mBFrITHF9gXXs/2PRtMgunqARusriUEpKLv
	 E/JglBMz12mGed1hL+yePPEbEc9ZYdk8CnmWTZU3PbA+KVM/7Y6Dk7SxIOOw//l/Pv
	 WT6aAYyNGtcBkMSV7KYWSUZwZvjijOs+SFQyK6aZGtvxyxTgGUW5Y9mtHgSEZvCcJs
	 D0eq7s/O/0WxQ==
Date: Thu, 22 Oct 2026 11:27:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 0/9] bpf: Add support to allocate user page
Message-ID: <atnk5kjaeHLhbxVh@gremlin>
References: <20261021195759.119421-1-jolsa@kernel.org>
 <DMAUMG9WL4X6.12UEJJMJSW54Z@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMAUMG9WL4X6.12UEJJMJSW54Z@gmail.com>
X-Rspamd-Queue-Id: B72B6180008
X-Stat-Signature: w11or1uyur7wcesx7joxtqn5mdpsrqon
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792664854-56356
X-HE-Meta: U2FsdGVkX18XTaAlpDEpmAnA6ozTiftzarefhuWjGiDhklPzktc0gIzvyNroIoq6aGIfRfeSdiaGwUVVFuL9KHFrf5uoGA0+pScY+HQP2sfvnpcFmacFOIJTo51nXw+PjWVikLIC7deRWiYQjb2PuFcxEnBEWXaX6Oub8A9vS9K8OspbWTCFqqjiJOKwVzOVchbQC8Hrt92dZD1o0mcPXLS9UEYkH+CIhgbQJ+ILtoUPi73p0prvvpA1PJT3XbUKPI8CJ+tBPKOUdDd8YcTknuL8aYsH28fFtPyfKie6y4tr2qnj3xwIH42xl/nykJv1+vpA7t8DC3NSRt7LlqkHT3IOx/omvn/mmayZ3d7dav5oILszMDxxJsARaee0Q9Qbclj8Kak61YRXazY0iBGhIkd8fJUuRQTmMIpG6ob75njpjK0+dPAbQ0Kq5vJwipqd/CMuoVYJBnFQXmP07EJnAbyIfMWeyu/yNX2OP8yaN4YXMd0wC6ijyQHqq0UzOLAzB8PM8BmNciu+MmPdNaAtkZAAjW84XNBaj0OUXffObL/ZHaQxgberT3zBOq+8cZagcSNZByqbEOUTJyeSftXa16oQjcB+UEvIq3jQqIaXkvsKb8AYpx/5E7Zko7T5fu7kO4xKZp3PoHB/zWm9uQ+C3aNzIWzkR4x7owcPuBWI8c9vyNQ0Xa9ANjo+AjrIBbIV7NaOoNmVyuZt/SkB/MSzubQB3QFE1FdDgRxFwOm8+JViYF3RUbsXef1yk/Y4vPpGJe++DsJL9+VhUu0KP12K9m0k/5scHqVClArtVzetka9jKMiaSjTrTJZ4iLafI1aDuXlXkiSzTGZugVuZp/HvHmm/p1+Osm9fsb2PAVgrSKXOxulW+OL2N3bpbHkdD/MBoOC1RPy0kX851B30f9OhFPWPSdwfLASuops/DcWPJPgKm7jXW8KcXvlxA7IrYoUuqa+KTMhEN7LgW4iwPZG
 iGm8OzE/
 mSSwqnIrGbtEEFRzT3iq6CnUcbur5nv+eVCYnJDsu1S0fX0HQV9ntJAHDhYvYwGM5PW04QzGmnyAUCJ8D3cwaWUshptBr3UyOwLpQj7RLbaGCc/VetNGEO104n7NLhD1q8QR2QEAXgBhdrAwctzus28t2d2YvlGT5Cb8N3PoV1OKO/EYuC3Amm/mbJm8eVTNDn9iB2IU3Uf2oECMA5lwYpZaLEubxOlq5+jb/Rp9VALLGhFI80dDunU+9DStZGn+Y6mJTg9W9BUBV5MGtVtT6VL/zetGXz9lJ3Xytf5Sihu/eLv3qAom6ICsc5cjRQ43H99KFoODlmVUn2RvLpvxRSoJxMRImQWOx+40H+FtpLSpoCII4kQVYcOW0/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 09:53:47PM +0000, Alexei Starovoitov wrote:
> On Wed, Oct 21, 2026 at 12:57 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > hi,
> > we have few use cases where having the ability to allocate normal
> > or executable user space memory would help (like to replace function
> > in live process or change environment variables)
>
> I think it's better to do what debuggers do:
> vm_mmap() with the final prot and
> access_process_vm(FOLL_FORCE | FOLL_WRITE), like PTRACE_POKETEXT,
> to fill it. It faults the pages in, writes into r-x private mapping
> and copy_to_user_page() takes care of icache.
> Then no need for bpf_user_page_exec(), do_mprotect_pkey_locked(),
> the marker, READ_IMPLIES_EXEC special case, get_user_pages(), etc.
> No mm changes.

OK thanks that addresses my concerns :)

--
Cheers, Lorenzo

