Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0652CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 19:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2A56B0088; Sat, 10 Oct 2026 15:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263446B008A; Sat, 10 Oct 2026 15:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155DE6B008C; Sat, 10 Oct 2026 15:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA0166B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:34:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47E171C3EF7
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:34:07 +0000 (UTC)
X-FDA: 85307717334.18.99F7B56
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4896720005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:34:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="a/y+EOXT";
	spf=pass (imf03.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791660845;
	b=NKFSKVKVWi/W+3F5tYrD7sWh6tK+6ywAHxv/KsMMmg3HFdan6dzVrf3C7MWZnC81tX/JnH
	FTG4ztVd99XIg0IR/Q/kZSxXK+Q4J1G6eAjMNhGpHE1mhYBbgHWhJDvgzEEF6gmftXUzGI
	ImmWL4YP5WnwRMx90jdzDNyhD8LRx4w=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="a/y+EOXT";
	spf=pass (imf03.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791660845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwjZ8HoirsbhBHMOLTlle3+6cKbWORhpDE5jw/lvyr0=;
	b=iDxipUd9UR9cDwbE+gfoqRIR4n0d2qmq2XX4VYGFHKXFWKm7JJDBIC5NK2bb6EqE7CIH9o
	2mW/wwNKSvGpa6ulLhPyVJmCXQlTyq6vL+x/JD8TArk+iMLqnJx34kVzjHj1IEv/RCSxWe
	WS3p5TRrd/O3pZJDkdg/TU6dqBY06p8=
ARC-Seal: i=1; a=rsa-sha256; t=1791660833; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NGtw313ThYAUgnS/n8XOc/ay1UJa5UFJLVSh+7JkLdwwTMCtuLUp/iiXRNMby159dLvL+n7YOyonx3m6eHiJlA1WTSrXcwNRUTxiXn7hbRVj7F+OG0CLJ8SYvhSHbgMbKYQ3fi6f6m0pZz1VhzMhayqppAyJtb4yscR+1fc7614=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791660833; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=DwjZ8HoirsbhBHMOLTlle3+6cKbWORhpDE5jw/lvyr0=; 
	b=DoLrpV8+Sy9ppjAYAmEdzZpqRKlGjW3v5W44GJb6L6fLA9K9wX0fm1g1D0VAAoIE8XHBFm/rpIhbxrcAQmv+yzALVQQFfZDC57+oP4K/T3hwnn4eLDbi2CKBSJJ9VMHuNbTeIMgI7xoxOANvzfAblNsfe5KmVPJ1bFyz43oqGEo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791660833;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=DwjZ8HoirsbhBHMOLTlle3+6cKbWORhpDE5jw/lvyr0=;
	b=a/y+EOXTa1LV1bC3hn0jRDa1LPAg4Q63p6uzODb3LPbS5Me3kavOP3IGKbgC8zBL
	jMmEtV6dR/JhOL+leXHTsi6vlcju4ogCsj3X/g/q8Nqzbb/JmqcpzlQOu1FgyhP/TZg
	1uSAh3VS+eXkibadAp7HueteUna1Lr1nb3d3COWQ=
Received: by smtp.zohomail.com with SMTPS id 1791660831468655.5458899578292;
	Sat, 10 Oct 2026 12:33:51 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 04/11] drm/tyr: add per-file VM pool
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <aspyoBHaSaJpMxJv@um790>
Date: Sat, 10 Oct 2026 16:33:32 -0300
Cc: Ke Sun <sunke@kylinos.cn>,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 driver-core@lists.linux.dev,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B20D93F5-4950-4E9C-8E3B-E2DC476DA539@collabora.com>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-4-26955fb111d5@kylinos.cn> <aspyoBHaSaJpMxJv@um790>
To: Deborah Brouwer <deborah.brouwer@collabora.com>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-ZohoMailClient: External
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4896720005
X-Rspam-User: 
X-Stat-Signature: hoodtxtipp4fgjucuprno76jnb5q4jj9
X-HE-Tag: 1791660845-200275
X-HE-Meta: U2FsdGVkX1/wfQqZ8eNWhKpx2m6Dkos9gSgqZUn+JgadI+Ig6dgKr6OdeaNP6a65fN93zYgNBB7UGvUjkwRQySEU1ug7UkQTHY5r0GxHTOf85CAL8IF+uUfmRcz/cE03/Ld4KQhq1MPMj0PigwlA8ltoCGQRpGUZBuL8h2yBeUQZ1guXUEju8+BLoStAharQnjhp2dEzWQ+UK2A4XIuA464zr4vuvvWR99nHtfeYRmlkcn8SJGCTerLgLjmz6WOdsnDRzKXEjsF3YB0WkqLjyEhio6UjmHUZrbam0GcfNHCf4veGJF1XzKl972+MphTy+Bx7YaZDJQJfCoEjkhYQgC7e3r831eXFR61Q9SVLUBPup9t8pMEdoTMMJNJXhDcv0ijzl6S+LuqVPEmC+JlQMEPkgQRLMMmTGG8DY0/rZbWDpVW2Yfi4lk6l4RSixzU4Cxf+2g+oTpXPkqYAjex+zIZt4RebszelXumBog1yS+EwPp17f6/tStfeYzX6ROrStOSfKKjLIRF85iR/rApHTZxd21wPe9PMSixsSuJgobidut07ktmy02omE/Xi5reTOVWJfmLsdwI1s59WAK1FvGyVplXSk+j8zzkik1Hhs4fmrW9H3FzsKIVE9sgckj3wnnVMz/r3EWPxa9U0yyCpCizt14o7BfSg/87gre2mXAvf6x7DJ0XmPCtrKrdsKIK67j6XCuiJblTzp1maDyqTVZuIHBHJXWEGTqAkbnLzePNYx9rdTlKwshPg1oJzHKhd/Cu28QOYcZ7WJ9fYyp+6cExIYKJ5PI6NpOnTrSYNVMqZ6gunLeUttPXfg7MYE59dGSQK1OV8Tu2gW5ACv+b2y+4cD8SN6Vt0Dq9aDWKRfsoW8gdaI5Rrhrd2OgOGzgKZHCMQ9E+RdpVruTWSV0kKEwb6IErShrDyMjHf08lQuba+2AR3o/ZhP8A5U9aeVcYnQNnBmNfrIAjP9JDIyan
 0B8Kkmx+
 Hp1LKcaa91W230zz7bKFEJbb+nYW4GkANZl9Whf6DWrqhQC7XF16fm/e0JU07m1aiYxfMInur+qwotmqd8eiXX2INl1ZtY5R3Riq1Atxqlu03EFIMvkm7pHATCRE4m11g1iT9CC48tn6exkWGdFlUIR9Kmi6x9hJCtFdEbiYckAcckTgiO00zv9zNroeWqHLVU+hvYwVbjtJTStzwWdABM4NzS+/DqoirZVHs3SjdBLp6q2Y7SXRfYfpvAmqDRJ0ehFjvWBA9MCwvOkE91fvRcJpq60PLmhyIbwBLTTPBlWqNTr4AkyudRkG5zEBipkXBaJKAFaKUVEkrEpKRuAeKXqlrSN0Ure2l1Fiogiy7hDeYeHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deb,

I find it unidiomatic to have containers destroy an item if addition =
fails. A
more common pattern is to return the item in an error. Something like:

pub(crate) struct AddError<'drm> {
    pub(crate) error: Error,
    pub(crate) vm: Arc<Vm<'drm>>,
}

This would not convert automatically to Error, so callers could not =
simply "?"
it, they have to handle it:

pool.add(vm).map_err(|e| {
    e.vm.kill();
    e.error
})?;

Don't worry, I plan to remove the need to manually call kill() soon, so =
this
subject will become outdated in the near future.

Paths where the Vm is already in the pool can call kill() though, this =
includes
remove().

-- Daniel=

