Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FF1606A330
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxOP/HxQ
Received: by kanga.kvack.org (Postfix)
	id E8F3A6B05B0; Sat,  7 Nov 2026 08:27:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FCA6B05B1; Sat,  7 Nov 2026 08:27:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32226B05B2; Sat,  7 Nov 2026 08:27:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA9AE6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:27:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3706AA031D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:27:28 +0000 (UTC)
X-FDA: 85408399776.24.4EFF387
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9378B4000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:27:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DxOP/HxQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794058046;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYuEro8Zcjv6YME7UDOYZvPuRG2H8jml3uCqzjrXjAQ=;
	b=v0mFNntTYkB4zYEKzAPrHjwNBtWS8X858XXzGSmEk7YaFjzWMAkpvGXKa9qq85HErTMVAG
	qubTSYIvuLVeC50GE/QCGC46ujlhtSB8xuWwLsaOvt1fgtmhnJ2I+/9eBOKsS8iTZTEOkA
	FS3L2zebpCkiGNtoV91/p193GbYwTxs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DxOP/HxQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794058046;
	b=3eavEXl5w/TirG5uPCIB43IMEltN6tjitw/m1gFpZMESIWwnQSTzNpjbBmrlGtFuQjPsCd
	F46XtvqUERD04STtqqdm1S/aZ/w3WN5M7PB5WPTOYf+KMkA4o7UPzXzcX5HcyETPaR7ekg
	lKFzlXU2wvBtYFHQ767isBG/rZUDtdk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F8D66014A;
	Sat,  7 Nov 2026 13:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330761F0089F;
	Sat,  7 Nov 2026 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794058045;
	bh=BYuEro8Zcjv6YME7UDOYZvPuRG2H8jml3uCqzjrXjAQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DxOP/HxQ17GGhExqOPnOumO/V/teeSpqm9C9gguR4xrp2sMcFN3zsxlmtz3+3JyMg
	 3Zi9YHAsAmtOi7ERD+zvDsVpnl4qRla6FXXP6SwihbgS1XGEQQByYi/hGaPhZfEQXZ
	 +iPqG3aqw0Mc/HXAZZDkObIxhrV49gB42KuiWd1F9mt563xQrYkKLjXcv6grdHw+/L
	 YROOQDkMoTSNRr6uX50MIzWJVtj0FpZp7Fc/wJsOfcVyMSv0Di4W3PFAuQlHGTPjJv
	 lbwtegD8FpR89z8SvkZSThW39mtxzdRJmnvNWJm3WlgbVA38QDWWaSXWqGq/OomZBI
	 4mw3Imp3BpWXg==
Message-ID: <sashiko-outbox-202918@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/7] scsi: sg and st: account the command buffer memory
 to memcg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tao Cui" <cui.tao@linux.dev>, akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk
Cc: linux-mm@kvack.org, James.Bottomley@HansenPartnership.com, sumit.semwal@linaro.org, christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org, will@kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org, bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn, media-ci@linuxtv.org
In-Reply-To: <20261106131829.3228926-2-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-2-cui.tao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 13:27:23 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9378B4000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4z59wp3tyfbdfz61e7at8xf6pp9apaet
X-HE-Tag: 1794058046-833745
X-HE-Meta: U2FsdGVkX18+h3z9jjtjlvgwLWdfmJsetKTniyr2YaCjMUMGK9HkJFm4FowruVRd6pqCneGvyj3lDd4iqM8ISkqDqiLsvvxtxDdNZXW612XmVxR2OmAPxOCqjV9poGXKp211vKNtEnWcAbZApnE3cO2Mh5Fw95Ghaci6tKVJ+81QNBcp10jIR1aAH+Z2NceUs//HkVIRUtDqe9ZfCSvYwB3LPIZnd3F6HLJYW+fC0mu43onHGc5kYRX4MmcQMs7K0Srb8cV512S+anLhNy/2pXHzyun35Pm8d9g65Ozm9ugIF+HCuPwpMvgnn5sRssbzCR26mnu3Wx8zAK3KfVZkv2b4F59pD6F8TRTS9+86gbnL8MKErNQdu2a1jXyXubS7SS1gKtEywZahLSZtjMacuK/gezT3mJa2N0yvcwfluRP4u9xTm2y1ej/I6rWydKJM4FYkPffz8P/kvnF38dLI1HPBmcm906tMVUO2eLOSkE4XhwqtrmttmYtzn0UrWUxLfXXeiCD550xyCtHNAWoVf0JQfpHXIxTO+GyyfcsXWdMsoCRz5IVhRgv3n4GJa/gGZpSSuaobVsOx4uO8sAUzSedQvcbURWtpNdi5LksSZ+sQnUHU74c294j/Dk5KlnTo9TcGxqU3DRYrKRdIdigHYNAbvnOcImbxlza/C90KVagcc06bQ8k1G+oNPreIcLxJB9mx+bDXLmLIRafCRntcoLFjU+qurZLgo1qktDTfLNQvcrDNh1GOOYIBlhgQhRS2+l/Cx99cJjaySntT/lz6D+sf0Kduobhbc59++1Zd/wYCB1CdaLKyhch7+JitgaKJMEXIZduv32vaACvG3d/CXAQjUeKxFk14Y71078F0tBktIK2CfrCQIGXo3GQvFdOSnf7GkUnUu/ylbYF41UaY2E+607OLd4DtMZ3+Rcj/Msk0k1DvV7zoA6mjbWb7q/AFwDHVr/HhvVnzHMqOFzO
 4TqDDeHK
 1U7b+l+6fhVo2vxyksDDzbbBwGCBp+XhLKlIa9YzRQ1Fnn/B6QST8QguoZ/2Moglm9yoCW6vIEENdPt0sRRQgp7p5+CzpUmvE81O2HH5sxWNm3Y3KlI+CdT5iQ4Kqkt1woq79BW9rFLIebK6pVTkBAFOURWVciNQaFz77PuXj8m4Gr836wJtGwH3Jf4G867z8Ftvbpm70xyF9HgxjlY4Qz/FJcFvCZbLT01GLLLBoLd9UCHlCeytPVTtie8H4nyR8OK26BMXZ7qo/dFr5g15Yo3DFrurNjYhOw5QNKelNtJmIX8PLha/IIKiTLgMv/kQ8DgJmHR7YEmJ8M1jhYgFwmmBDC5E1KrI/sjM4sKsngqmNatXq7XY4Nzo04PbiS1t3ayxViQYqao+sqbIozK+vwAxQenmCd40M9nR+sS7Ij1+WLO5g7orHlvB0uOyQDsRfNjgStKbx9GB7WoCjmWrrKtHIkLv1SolPJtHPyvMeL2qhsQP30UQCMNvSqKFI2J6aDQirLX+1a+bv//S+QNqnJM4sDSanwAp1ozqqc+wludOTWMrgSN/c2fHm7cyJ6tqCfDacrlFqHdwFmXZb3O/WTzprIvh9ZsL1uv9zeSs4h/eZih3RLklIp5BDY8VcaQ6XPQKQZt0UR4nM5YE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] scsi: sg: GFP_ATOMIC | __GFP_ACCOUNT in sg_build_indirect()
  bypasses memcg max
- [Medium] scsi: sg: unrelated and broken blktrace CAP_SYS_ADMIN gate in
  sg_ioctl_common()
- [Medium] scsi: st: misattributed GFP_KERNEL_ACCOUNT probe charges in
  new_tape_buffer()
- [Low] scsi: sg: commit message cites non-existent history in
  sg_build_indirect()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] scsi: sg: shift-out-of-bounds in sg_build_indirect() [1]
--

commit ec96b2b0cdd1df3575b4521cd9f81da9824bc2b2
Author: Tao Cui <cuitao@kylinos.cn>

scsi: sg and st: account the command buffer memory to memcg

This commit adds __GFP_ACCOUNT to buffer and descriptor allocations in the
sg and st drivers to charge them to the calling process's memory cgroup, and
adds a CAP_SYS_ADMIN check for blktrace ioctls in sg_ioctl_common().

> The sg data buffers are unaccounted: the per-fd reserved buffer, the
> scatter-gather page array, and the order-0..N pages behind it, plus the
> per-device tape buffer in st.  All of it is user controllable.  The
> reserved size is capped only by the device max_sectors, SG_MAX_QUEUE
> (16) commands can be in flight per fd, and the fd count is bounded by
> RLIMIT_NOFILE.  Nothing is charged to the memcg of the process driving
> it.  The September 2026 fixes in sg_build_indirect reshaped the element
> sizing and left the accounting alone.

[Severity: Low]
Is the commit message accurate about the history of sg_build_indirect() and
the reserved buffer cap?

In git history, sg_build_indirect() has not been modified since
aaff5ebaa269 ("scsi: remove the unchecked_isa_dma flag") in 2021, and its
element sizing has not changed since 10db10d144c0 ("sg: convert the indirect
IO path to use the block layer") in 2008.  In addition, the initial per-fd
reserved buffer in sg_add_sfp() is capped by min_t(int, def_reserved_size,
max_sectors_bytes(sdp->device->request_queue)), while only resizing via
SG_SET_RESERVED_SIZE is capped solely by max_sectors_bytes().

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e6c01..80d919fa5cf91 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -910,6 +910,19 @@ static int put_compat_request_table(struct compat_sg=
_req_info __user *o,
>  }
>  #endif
> =20
> +/*
> + * The sg passthrough of the blktrace ioctls has the same exposure as the
> + * block device path: holding the node is the only requirement today, and
> + * a created trace outlives the fd.  Must match the gate in
> + * blk_trace_ioctl().
> + */
> +static bool sg_is_blktrace_cmd(unsigned int cmd)
> +{
> +	return cmd =3D=3D BLKTRACESETUP || cmd =3D=3D BLKTRACESETUP2 ||
> +	       cmd =3D=3D BLKTRACESTART || cmd =3D=3D BLKTRACESTOP ||
> +	       cmd =3D=3D BLKTRACETEARDOWN;
> +}
> +
>  static long
>  sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>  		unsigned int cmd_in, void __user *p)
> @@ -919,6 +932,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg=
_fd *sfp,
>  	Sg_request *srp;
>  	unsigned long iflags;
> =20
> +	if (sg_is_blktrace_cmd(cmd_in) && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +

[Severity: Medium]
Does this capability check belong in a memcg accounting commit, and does it
cause a UAPI regression for unprivileged users with access to /dev/sg*?

Despite the comment, blk_trace_ioctl() in kernel/trace/blktrace.c does not
check capable(CAP_SYS_ADMIN); block devices gate these ioctls only on access
to the device node.  Moreover, sg_is_blktrace_cmd() matches BLKTRACESETUP2
even though sg_ioctl_common() only implements BLKTRACESETUP, BLKTRACESTART,
BLKTRACESTOP, and BLKTRACETEARDOWN, so unprivileged callers now get -EPERM
instead of -ENOTTY for BLKTRACESETUP2.

> @@ -1841,7 +1857,7 @@ static int
>  sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
>  {
>  	int sg_bufflen =3D tablesize * sizeof(struct page *);
> -	gfp_t gfp_flags =3D GFP_ATOMIC | __GFP_NOWARN;
> +	gfp_t gfp_flags =3D GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT;
> =20
>  	schp->pages =3D kzalloc(sg_bufflen, gfp_flags);
>  	if (!schp->pages)
> @@ -1856,7 +1872,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * s=
fp, int buff_size)
>  	int ret_sz =3D 0, i, k, rem_sz, num, mx_sc_elems;
>  	int sg_tablesize =3D sfp->parentdp->sg_tablesize;
>  	int blk_size =3D buff_size, order;
> -	gfp_t gfp_mask =3D GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
> +	gfp_t gfp_mask =3D GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN |
> +			 __GFP_ACCOUNT | __GFP_ZERO;
> =20
>  	if (blk_size < 0)
>  		return -EFAULT;

[Severity: High]
This problem wasn't introduced by this patch, but can the ret_sz shift in
sg_build_indirect() trigger a signed shift-out-of-bounds [1]?

drivers/scsi/sg.c:sg_build_indirect() {
	...
	num =3D scatter_elem_sz;
	...
	order =3D get_order(num);
retry:
	ret_sz =3D 1 << (PAGE_SHIFT + order);
	...
}

On 4 KB page architectures, setting the scatter_elem_sz module parameter
near INT_MAX gives order =3D=3D 19, so 1 << (PAGE_SHIFT + order) evaluates =
the
signed 32-bit shift 1 << 31, triggering UBSAN or yielding a negative ret_sz
that corrupts the allocation loop.

> @@ -2146,7 +2163,7 @@ sg_add_sfp(Sg_device * sdp)
>  	unsigned long iflags;
>  	int bufflen;
> =20
> -	sfp =3D kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN);
> +	sfp =3D kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
>  	if (!sfp)
>  		return ERR_PTR(-ENOMEM);

[Severity: High]
Does combining GFP_ATOMIC with __GFP_ACCOUNT in sg_build_sgat(),
sg_build_indirect(), and sg_add_sfp() allow processes to bypass their memcg
memory.max limit?

GFP_ATOMIC sets __GFP_HIGH and lacks __GFP_DIRECT_RECLAIM.  When a memcg is
at memory.max, try_charge_memcg() skips reclaim because the allocation
cannot block and then force-charges past memory.max because __GFP_HIGH is
set:

mm/memcontrol.c:try_charge_memcg() {
	...
nomem:
	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
		return -ENOMEM;
force:
	page_counter_charge(&memcg->memory, nr_pages);
	...
}

All callers of sg_add_sfp(), sg_build_sgat(), and sg_build_indirect()
(sg_open(), SG_SET_RESERVED_SIZE in sg_ioctl_common(), and sg_start_req())
run in sleepable process context holding only mutexes, so using GFP_KERNEL
would allow memcg reclaim and enforce memory.max.

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index f1c3c49466379..7083d37622c08 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3973,7 +3973,7 @@ static struct st_buffer *new_tape_buffer(int max_sg)
>  {
>  	struct st_buffer *tb;
> =20
> -	tb =3D kzalloc_obj(struct st_buffer);
> +	tb =3D kzalloc_obj(struct st_buffer, GFP_KERNEL_ACCOUNT);
>  	if (!tb) {
>  		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
>  		return NULL;
> @@ -3982,7 +3982,8 @@ static struct st_buffer *new_tape_buffer(int max_sg)
>  	tb->use_sg =3D max_sg;
>  	tb->buffer_size =3D 0;
> =20
> -	tb->reserved_pages =3D kzalloc_objs(struct page *, max_sg);
> +	tb->reserved_pages =3D kzalloc_objs(struct page *, max_sg,
> +					  GFP_KERNEL_ACCOUNT);
>  	if (!tb->reserved_pages) {
>  		kfree(tb);
>  		return NULL;

[Severity: Medium]
Does using GFP_KERNEL_ACCOUNT in new_tape_buffer() charge the device probe
context instead of the process driving tape I/O?

new_tape_buffer() is only called from st_probe() when a tape device is
attached, and both tb and tb->reserved_pages live until scsi_tape_release(),
so they are never charged to the process performing I/O.  Meanwhile, the
per-I/O page array allocated in the driving process's context during direct
I/O in sgl_map_user_pages() (pages =3D kmalloc_objs(*pages, max_pages))
remains unaccounted.

[1] https://sashiko.dev/#/bug/linux-ccac9556-cc9e-4b08-b44f-5f7ffb342827

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106131829.3228=
926-1-cui.tao@linux.dev?part=3D1

