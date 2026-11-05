Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470B9606A33D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=HodZz0mT
Received: by kanga.kvack.org (Postfix)
	id 6A2476B05B3; Thu,  5 Nov 2026 11:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655146B05B4; Thu,  5 Nov 2026 11:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B9B6B05B5; Thu,  5 Nov 2026 11:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 270676B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:23:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FCB01A0B5B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:23:16 +0000 (UTC)
X-FDA: 85401585192.11.56C1EAC
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 047B320013
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:23:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=HodZz0mT;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793895794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coQkw57ZP+vtxGOFNXxyJOYi0uTeh1KAeZgHd3m+lMA=;
	b=1IBpXVqeQMwBEgvW+EieSOhTxO1QnhijSfTcXSi52UiUOMF1s+8Io0gkynY6mM16etrgZZ
	/SRPq7CQH8yDhr01ITInSaEZBVrUl5UV9/eDXzRiNfiUiijhFLtu8HUFO9kVzOR5wbiPTM
	95kpTdhPIH67Lxuoc45ZSx/ajIFYc/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793895794;
	b=4CevnE5rgWq3p66klwCCTOQsd6XBCHe9h/hNPVeMIRIojZii2thQWApp80hFyWVORW6T9W
	ABDYL2Mt41dV7BCyQ1KJJJmzj1D6ffFwNcSwcZmigcCWP6MJHeHVV+Tqoh9u2aj2LxT8Js
	9cnejootWgL46xQr5JBaIOj2f5wxfW8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=HodZz0mT;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso4221663a12.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793895792; x=1794500592; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=coQkw57ZP+vtxGOFNXxyJOYi0uTeh1KAeZgHd3m+lMA=;
        b=HodZz0mT7zhhC5Ly796ARK7ANGieFeIJBrMgjrN9Ir6sDJeyS9NcepJ4eGIveOs1+2
         HkAdXiZADkWOo+pZIkKWq18DW+coc6Mr8eQ6IqHEPbTJdxMfGV8llpAF0NKfmVpWrAiy
         8F48jXKjpmTqDt3SYej5XFSe1sVHXyM8mVcvU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793895792; x=1794500592;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=coQkw57ZP+vtxGOFNXxyJOYi0uTeh1KAeZgHd3m+lMA=;
        b=x9GbNj7aU9jaVKoqd5PTCyBVincvSVXjL34Kqm8XRw08sjmf0MBufOePH8OFGBTUDy
         HNPGOER/1y5HsZfHDGJ4rZKQ8/7fa/48qohvfZe9mNDAu2f/l+emY99BGxpzRTRFs5wu
         ZZNSIKWD2ifqf8Ls5ljK/O5YtgUptPj8y2wQqZE90v7DWrbyGXCZ3y5wNSZVa37THzat
         EPH/ZHUT7gSCXT0mmUFanCFU18Vj/AnMVNGqi2gAkejh8XlbC6jxZyEH/B2UW43fcFbo
         MjYm5SI9b7bEUd3rLssku3iCgbMJrrbHmIUXnbfDPGF5P29SABWjiHJ83q3tDuryjMCq
         gJYg==
X-Forwarded-Encrypted: i=1; AKwUvBwWhkPWNHnDKEh5Yno7zVEPNBdCaMrSOcq/dLcK9FV7hmGvGUTX5gWja56aGrW93vtU1RPT24ayFA==@kvack.org
X-Gm-Message-State: APuU4Z9HLGmYkEaTFvUHfYVkTkzpu2c6x53muGR08V8LNNtJpfhTwTx4
	R6zrx8hi1v8F2tbciBMeZkDEUkchpyPQ3Gfge3PqNARemPjAkFvnYeaaH1B4wwQcR2coiw8qR0c
	MMPyrzw0=
X-Gm-Gg: AYBFou3ZHoBNShlaCjPYS2m+IQgz6ilST3YVdcuWzSx6A+sKi/0RwHAj+UWZ2GRPWtr
	8GjCBVNpXfRA2PWV6g0MVEeNRX8XMZxNjyXLRdG3hlwoqk+eTXE1FbnCEwlCzL+fUcXE+bmMasF
	Gx1PePoABEmgYxHDoyn0DTMZKa/7yUQvX86cjXLAhfGTMNHlBqF5I6IucvHPMkruy5gAF36C+Sy
	UTKfWG7v6m6NWwwFs48cmmYTvG0IN1XumV8Uqf2e4YD4cXpX68++uYal4QDEo9/sQWHSswHwQFh
	v3o9lVwfT7bt8XoVo4LKDvwk8AbOXI2BbwAGvm6c2cTyqp0jlLiB73Sf5SHb9HXSV2jON/jjZTs
	bnDowdKJJcHMDy8De0I1YL7gMvf2kJs+GbMQ+z+wrr9WbWoQE7AfnfRJenPHbAnwY9mpSrtsFo4
	AgxN3NUlJtCar9QbPLPyJ0fsUAH1sZaJJz0dMHaJYAHC5cihpNNdQlcPvwTn8CG6ghGF86KJd4o
	uu37yNHZ8OcQiyBLOcB+WwzoTN3dxgaXdo7yRe7NR3eR8FTsInxYD6C1TU+uV6S39cDpxvBY2T0
	ke9DKDcbk4bsxQCfd0Rgc6E3Kvfwn0kd+IWBgvI2ga0RZYjKaEfhxPauvCLds5CpHnMuJ/qofNM
	DUHvgT/23JHUL3YOuV68labM=
X-Received: by 2002:a05:6402:4288:b0:6b4:b032:c9dd with SMTP id 4fb4d7f45d1cf-6b4d3288c67mr16371445a12.0.1793895792334;
        Thu, 05 Nov 2026 08:23:12 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b5719cd68dsm1142538a12.37.2026.11.05.08.23.08
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 08:23:09 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso4221478a12.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:23:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBztp4tPbvg7FxpwQRiF2umjJDt0eNl8JLe8y+1IA4hAy+yy/n6yLKq/2PwfTDFu3YS6NKknv/Wo9Q==@kvack.org
X-Received: by 2002:a05:6402:3899:b0:6b5:76b9:5040 with SMTP id
 4fb4d7f45d1cf-6b576b95165mr2666079a12.41.1793895788549; Thu, 05 Nov 2026
 08:23:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au> <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au> <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au> <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au> <ausS3LQNkdc6lBy3@milan> <auxDm_YO4oACA_d2@gondor.apana.org.au>
In-Reply-To: <auxDm_YO4oACA_d2@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Nov 2026 08:22:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
X-Gm-Features: AclHuK_lYzOySVnPMTXkh-HXGHC850mf9gNJxZLEPPhkqoVD1gRX0QozBFysw7g
Message-ID: <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett (Google)" <liam@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zq69gqe5amdja7daj4c76jn6zmq9kynw
X-Rspamd-Queue-Id: 047B320013
X-Rspam-User: 
X-HE-Tag: 1793895793-538303
X-HE-Meta: U2FsdGVkX18oDAtWLtpPBUPqt8sXqRz32KKXeSQ1N1rYYTXFro5FJufOg2PYLowWvtK71LhGsFwIKCoh0ThUHjvWgaRwYkWAq/wGmkV06cfkJ2n3lNai2ctjnPTkIoC8iK2XbooRB5jrvHInH2bgPo9Rm/50HKR0W7/ybSQGBx9FNCCq0HfiDkyhryGH19rsXdnkLegg3Mnl9BVG2hSk+ufkaYH0cu1hIV+IVi5PJWna/Mo3Q7ylKPbXamjufShggNhoKlOtFJzsZSRirq14RPxobdnxrDhruKwtqBewH0jDKfhltLDTKk05/64XxmgKhIzbBD7rt6D1/Er3geIHAJu/jMflOlpL6p7curlANafsCJWkXhTj+662ILom3QBOyGy9EELtVxwZcBKY/P0nBq7EF4h+BuBhMzNxTzlpGWD4ueZaK7M8edtLdhZwjrrn4vcqIksSEA9NFsjaHDTaotJOhABZ+j5fVqy9X7XiwVC9XKsM2zHVYFp0FILLHKuvARk/MLzrQPZMb3ijtaava4R2IzXAJm4SFBGTpTdX/wBEjnFLcXC+a2Vf/3Y4NZ1ULOM2Yb8I5wzVyqA30WWlvdblN3/aeoK8ZVO0aEEPgw43ZFg6BCNUUsAjOsO35uGOj8FnHZxwOkXL0cC23aYVpmZ5twtAdB8Ho5NdRGPzjYdBXyvMdluL6fG1vuKGN+tuNni4DvQFGciW4XGjRQjuI8vaCHNNkEb9p35iaHNuAQWVDn3n3Fb8sHVbQ7WTVatSjEk2iJZW9HcgbRrPDkOfUTNbBH/+lO08wYCXBIj7udCsL+pSHb3FIizCuGewxcLDlwlPhdTeTmoBZR5dXhHt+h4BG82GcngOX3oM1FpilXlpETiMB4DiEfUn0cYKrBb2jhDcwWBW3EYRdl/NM10PXZqsXwC0rC3lohLIxFkmhnwUElvu0b2lfXYXzGuQtRg86KCLbicfpIMFjlA9J5Y
 umU1T4NP
 aEvINsgZKgZF3+3khYOmwB51JZqEBLKW8Loo4KLH0y42xYSTWp/5In8nnHw9tBI1F/SocJpvslbxvf++12cvyhsOles6utajDSKjDXp/tN00vrW0VZoqq65kseOIMatnGxHwYa2Er1FuKzYLXYivwIRGNnfUVJN4SRqODgOxl9wxfCcihULv+Ht+dxpkCyZOsVNxWCN83KeIKljISt38YRwksJfnKdZ49XROHTGUS1k+HtL++x+KAKMoMcz3L5AIQfweDUermrXwvi8NBBzQoASmmunJkJbjuHtaHYpMlSL2Jkq3tuqnitQ3snxxnKsHzWYRN2J/sOKzKGt4duhb9uuyyvVcYehTfFgYa7pvmNwIei4QDbEETTmG1C/bpzs2aabwVxpEZ/hlyAvsLZkQ6wNPKadCD2xJCUe/23bPDwcqUUv3ASzaglHkIpRjb5cvby/7nze4Dx9Ddn6gQD4tUFj+l3EVo3lAEonLheK9ttpZWUIUToQ5I/Ta+i6HY6Eo2BUOMKf4j8bKs6+oDA+eTZnzV+QCybixxSyrTRR6rGQxk4l43QuRadcldNxW8c949Zr7pyNJIVbiEcqS1XWnbRhRKLHxKb1WtWr4G4GbGU8qqKfDkYYXJ9PfGEaTruesvRgNNveHMloNxX9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 at 00:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Nov 04, 2026 at 12:11:24PM +0100, Uladzislau Rezki wrote:
> >
> > There are users in kernel. For example:
>
> Thanks for the list.
>
> > drivers/GPU
> >     /* Allocate the file in vmalloc memory, it's likely to be big */
> >     iter.start = __vmalloc(file_size, GFP_NOWAIT);
> >
> > AMD-GPU:
> >     kvzalloc(size, GFP_NOWAIT);
> >     kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
> >     kvzalloc(ring->ring_size, GFP_NOWAIT);
>
> These appear to be executing out of process context without spin
> locks so they're not really GFP_ATOMIC.

Historically, GFP_ATOMIC and GFP_NOWAIT have been largely the same
except for GFP_ATOMIC eating into reserves.

But I wonder if we might be able to soften that a bit, or add a new
form, because it looks like the AMD-GPU case at least doesn't really
care about any kind of "don't sleep", what it really just wants is an
"optimistic allocation" - try to get the memory, but don't spend
effort on freeing things if there is not enough memort.

The AMD code in question literally has a comment that says

        /* Dump ring content if memory allocation succeeds. */

so while it's possible that it has some atomicity requirements, it
doesn't look that way to me from a very quick look.

The etnaviv case looks to be the exact same thing: it is definitely
called in normal process context (that code takes a mutex lock around
it all).

So those two cases really don't looke like they are about "atomicity" at all.

> > net/ipv4/udp.c:
> >     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);
>
> This looks buggy in exactly the same way as rhashtable.  It's
> called under spin_lock_bh, and the same lock can be taken on
> the softirq path on another CPU.

Yeah, that case is definitely actually atomic and holds a lock. Not great.

Is there any way to limit the vmalloc() case to the actuall atomic one
and just fail when it needs to busy-wait?

               Linus

