Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60B5606A337
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mcN3jL0x
Received: by kanga.kvack.org (Postfix)
	id CCC0C6B033D; Mon, 19 Oct 2026 14:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85DF6B033E; Mon, 19 Oct 2026 14:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44EF6B033F; Mon, 19 Oct 2026 14:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 861616B033D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:34:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16408140732
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:34:12 +0000 (UTC)
X-FDA: 85340225544.25.D6B7256
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B3D480006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:34:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcN3jL0x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792434850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpSk/CbNOxgm/YwPtWLbatYprzPLT2PIdzvPIH54y58=;
	b=VekF61cUl1UlUc4ORO/5uxAKTrIpgthrbSq1VLoAViULprc3T6NnqUP3WQCW9KOjANSoP9
	qwIRYycFH25rn2XVhvxkE1VtAQDHjojQ3lr8SieqfVfuFFG15IuEGsnDdupzWVAnSs2JXB
	TLL8JGDHc3Rgaf7VyE7LtZPf1MvZ1qs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcN3jL0x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792434850;
	b=69eqIwQnz14/ywaNPXaOznRv+reHIxKY7YRMnaALiDzRgFlz0wVHXvzwLmZp9Oh/Dga5qt
	+nP8+moaoQJSMyFrsUgcY+SM2ccf8SzK9ux3mFzuAb84VH4jAwrDjiE/SrNw1meGKQc5Q8
	Y0lXG3SFaPsMM2/BsOkgYIEZyxjnN08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8863A602A8;
	Mon, 19 Oct 2026 18:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63DA1F000C5;
	Mon, 19 Oct 2026 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792434849;
	bh=fpSk/CbNOxgm/YwPtWLbatYprzPLT2PIdzvPIH54y58=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mcN3jL0x7o07gopqYbe6aQDb3uAGUgaxOQsFsgcY4yYkKSBZUled8S3ng4uax5VRQ
	 Y9ronnjw4+MQOAJ9bcE2XPVTC+D0sSvIDnqGKDIIoCDTO/HgDglU463/FRXUWMyIOl
	 E69fanaXZo4amEpW0sIDvIE7dZ29p4YQTGmgqlH8Y9Q3F3yUyHBPIX/qrx2UehUV5H
	 9nVtpPvCTMSm5twqXn/1Tb/qG6qUozGvtyuLn3/J5tLlNrz5sAjX4XrwemqsZ+4L/b
	 78TxvmfIOzAkm0A0Igc0PpVop3siJ/0JzrnNxWlqiz7gDtTzm+i5tF/yB3WuJrcYRe
	 f3y9qRN7JpvjQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4D490F4006C;
	Mon, 19 Oct 2026 14:34:08 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 19 Oct 2026 14:34:08 -0400
X-ME-Sender: <xms:oGLWaiqFvBURSSl0gU0eKj5KT_8cztuwHdKcJzxtN62_DMkj1os5AA>
    <xme:oGLWardCL6tbTZv4_8WDs5ufaImxCQYHhXsOCmshAhUZX4msruc9eO9PKjrOh7H4l
    965XpDX4It-QlSsGFKWqt0ZIfzSMnP77CFjGn8babFZiYpXFAJkSa0>
X-ME-Proxy-Cause: dmFkZTGU9dwEU4XRK5nfGJiAm4glnmpJQKWEZoqJtiBJkpSTPtHDUzcNFeKIV1MVYcCjaB
    efQJ3D5ne3hBoH3g4G+5JTBy2dhL/NzUjEcCd+BKoakAPgCNfsgXVatn7K99IqrxC6wkvh
    f4fbA5ujaLZZuTYe2mCnFgn7FxpCHqpKccrLgc8HDKj5jnv15GFdyQD448mH2wGhK6BKrj
    yMg9Z1NF84Y98QZDVhK8TeJ2DayFiMqv3Tc3085uI9nJS8haoO7AhZVKfxsPTam18dQUX4
    8jIE8Bd4OBWK4W5B+7a89Tju+Lo5PS0G5hg7LtnbEPb46Ao+zMycFo6IGpGotsiACSPPKu
    n0Z3qJ6TLWRoynA1ICgbyIOI7SLHtquS6bEjnt/cfBzzF6PMEDQi1G+3jIuUx/Jb2fVxWv
    UNTS2qjqCGQaMD+Zw5/mw10mpm/+KIDA8WNGtfsdTENCHHLdAfJOmBhYI8GvEHrKBTosCv
    bcttISHXbnuav/VEFCbLqjn8eoZa60VOlJCbA3oB2kOIMYLlm0mFTIXt2HXTS6vUpjTMQt
    n1JR5r+xM0IWuvKj3MXhSqv+gx9bmiCYBWVaEGB/pI7iadcisLm2WuOYQvlKrNAm/ZGoXx
    tvbQsHJ9RW30Hz3VAAr1wWodOp7THzk2LTtEjRffH/gjhMQaXPe8u4finxog
X-ME-Proxy: <xmx:oGLWavga5e8muFHTMT035QeK7vBI_wV2cOpOZB08fRRcN1NMQzB2tQ>
    <xmx:oGLWakIdZhKUF7o5oh9j00VmfqpaThVo1RXc9HEVoJQVKeWPMPOmJA>
    <xmx:oGLWaunONJIGdi-BAwdqq2J-acghmrbjGtT_mgDw7TciE8A3gdkeGQ>
    <xmx:oGLWasPtl9EdzlHrFRNJNN9LJTTq05cjyP6goD9Yjcte01adCvc1NA>
    <xmx:oGLWao6PAYSqOEbEf6Nt5kRINYVMyKxFvGlFOgEvVy6hpj5_u6h6ha4r>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1A8A0782738; Mon, 19 Oct 2026 14:34:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AS6kSLE8WzSk
Date: Mon, 19 Oct 2026 14:33:47 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Mike Snitzer" <snitzer@kernel.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
 NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>,
 "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Message-Id: <f39bfe92-8676-4241-bb4e-bccd838ab99b@slotpi15m67>
In-Reply-To: <20261019150725.1507-2-snitzer@kernel.org>
References: <20261019150725.1507-1-snitzer@kernel.org>
 <20261019150725.1507-2-snitzer@kernel.org>
Subject: Re: [PATCH v5 1/6] NFSD: add tracing for how direct-mode READ and WRITE are
 serviced
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B3D480006
X-Stat-Signature: zp6cz8y4tgcz579wiwewibx6sktcma1u
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792434849-43407
X-HE-Meta: U2FsdGVkX1+nxf71z2nqwllp11KFGFYU3zfr+/CoJAxWwDO8AbfwxvGcbUggM236j9+flYw+PBZKCqdvYIOHKfjVNgcFeA+G3rlqPH9CO0fhko5WZPVR8CAlnpZgcEoJdPfz0arWWiE/okQsLDclgT1BYZ73FHFlDI9P4w1RWi/BZ2UgEKzA5Wfg6z92+XgAIlRXKJWdVnOtPMl3n4OvT3yeZvLFKZrHaJDmshdkqmbGPzfTe4Sjh6nYRL2USDT6CEwZQwdQwO0nnkceDgJji7d0oUtMDRXYGSK/MjV/Aoy0xA1+Ec9YIi+FW5ObZ0p3qGOH5kU+4P6fDyYq4t9tZBfc/Pfpngo30cinfUMT0ztM34qRa1DlXmtvlsLNp1J+a5tghCTnm3Li18JqOEa/+6pMmOPCA4qWs/JO0I+O0fNBuo8udwu1H8hhaRiu0OKyP4MvD6A8M1LAdEEXaEAMLQsC+M1xGuQynukRj6OgvVPyv9r5CQMJgh68mmtpUUDYrxw9S3+RhSw9qozgQSG/43+LeMOyoIKgarc5RXuRogbhcjuHfYbYQ3P4Tpz4iAntx0baUB9Tj3iPxcq7lbnagCof3DvhMUrX5KZihUcsqc9ENYL+v6dQq6LGz3kguFcuTCxS5PFdkLih6//ZjN/mEVLUB7IAiP9Jj23Pm6xtATTQ6N9sECv3K0KkjH7Mu+zC0UKHrazgS2nue5IaB1s/kZNCHEz2GkEs/uLo8Aho/W/gzOb6A5OvbgkDxgYFf1PhxhbRwKLzUpyXhDuOISTGF73wdBKLXC0J4KGeV2FVZrmACbVWOvLHLwchiKy7VUUkXjdMo1rm7aUUA+icHJ72Ve+SeVp0Rk2jz1wkJyMrIu+sNQgubgtSER9TsZj8MxjRxIf0kW7sOo7MS4vXp/V5wX5/IUqb4lzsmy3gPTl1a0Uxxp0y6+Wshmvm95SSvX8PWR9bH7a+5Rpiwk+qykS
 /fEOhLAN
 yAHwsf+kXqMIYsf3QckotCs4BGIiDQkWzAilmJo/uOfQqqp90AzLQ5O93ptvfA8k+YZhii8FMLCyNo8fCHiYVIXq60myQ7dJnhyENpFNV3QeKIahLvVcHjDYvOEEQHrBGPllER5acSs4cT2I6LK0pWMdCQoYfMyUoVEIaaVp4sUaQ2qAJIxQXFI4VwLaQpymr922Hh0WGNcpKCQ9uqAakVjZ2BwP/panZwP/WlWTLMfFdO2gjAg30iVs+P865a4pyRwl1zphK41Nl6bx39GkLPAm/HZzjjJgtZHSKIsXaTNXP/t/udMg7fI6jaNq6CB58YYtkjhfjRwv29PdV9wLgiZi8vtSncL4S69yu+xB1siriQF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026, at 11:07 AM, Mike Snitzer wrote:
> Add:
>
>  - nfsd_write_dio_split, emitted once per direct-mode WRITE before any
>    segment is issued.  It records the advertised offset and memory
>    alignments, the payload's offset within its first page, the start,
>    middle and end segment sizes, a disposition naming the path taken
>    (direct, no_alignment, too_small, no_middle, mem_misaligned), and
>    whether buffered segments are issued IOCB_DONTCACHE.

Let's define a single event class and then use DEFINE_EVENT per outcome,
rather than one event with a disposition field. You'll notice this
pattern is used elsewhere in trace.h.

So nfsd_write_dio_class with the alignment and segment-size fields, and
nfsd_write_dio_direct, _no_alignment, _too_small, _no_middle,
_mem_misaligned fired at the site that makes each decision. An admin
chasing "why isn't this direct" then enables only the decline events.

Also, let's give the READ side the same treatment so admins can see
the decisions that prevent reads from going direct.

With the per-outcome events in place, the dontcache field on the
per-WRITE event is redundant: nfsd_write_direct/_dontcache/_vector
already say how each segment was issued. As it stands it also
misreports the direct middle, which carries dontcache_flags
regardless of direct_misaligned_dontcache. Consider dropping that
field.

A few less critical items:

- nfsd_write_dontcache and nfsd_write_vector are emitted only from
  nfsd_direct_write(). The io_cache_write=dontcache and =buffered
  paths in nfsd_vfs_write() emit neither, so the new DONTCACHE event
  never fires in DONTCACHE mode and the commit message's "now fires
  only for normal buffered I/O" isn't right either. nfsd_iter_read()
  covers all three modes; please make the WRITE side match.

- If any enum from vfs.h ends up in a TP_PROTO, note that trace.h's
  own #include "vfs.h" is after the per-class events. It builds today
  only because xdr4.h pulls vfs.h in first. Move the include up with
  the other headers.

- mem_offset records bvec[0].bv_offset, but the mem_misaligned test
  is on bv_offset + prefix. With prefix=100 the event shows
  mem_offset=0 next to a mem_misaligned verdict. Record the quantity
  that was actually tested.

- The doc says iomap_dio_invalidate_fail "reports an O_DIRECT middle
  segment that the filesystem serviced with buffered IO instead". It
  reports one cause of that, on iomap filesystems only. ext4's
  fallbacks are silent. Let's narrow the wording.

- The doc talks about start/middle/end segments while the event
  prints prefix/middle/suffix. Let's pick one vocabulary.

Jeff's comment about the ki_flags test in the hot path stands on its
own. I'll leave that between you and Jeff.

-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

