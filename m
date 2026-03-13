Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F609105F797
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377C06B0088; Fri, 13 Mar 2026 07:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3254A6B0089; Fri, 13 Mar 2026 07:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2074C6B008A; Fri, 13 Mar 2026 07:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 107996B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:08:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5E911D2E8
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:04 +0000 (UTC)
X-FDA: 84540765288.22.1E617DA
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id D2EA64000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V+cY0BjR;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773400083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4uzVIqz7pq7OLZ2jBdjHr4kmFUvKLHY52M+cHA2QeM=;
	b=oXjkHDFIjcl5byExo6WXGHdlVsVH7uEeSe7QG+0DGzKvOrtYblr1tKbDF0VNez5vBZlg9/
	//FVYdOp4oNHdR94U78BqugTtGiOOwTMw34zZeykcjS4b9Zqy7SOrck4dHB7e7hDK9n3DA
	BI0yJ7IKrKPdECb4EWB1p1y2UW3b1hs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V+cY0BjR;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773400083; a=rsa-sha256;
	cv=none;
	b=ayk5nClmTPHrrWP+HcvRmS31ATwzGR5qrete5ZBPb1QkOFaarz+lYkLOmJo6edDsvrwr9f
	WXAxbba3MgPNpGFTreSK+Do3sBq0pAbZzsB6LD1JI0D6gcD6hCzDvbmL90Gc5YlwwKB0j6
	uoUjyhO7ijVLV9nL4kLgkPQItbUjt5k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773400079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F4uzVIqz7pq7OLZ2jBdjHr4kmFUvKLHY52M+cHA2QeM=;
	b=V+cY0BjRyCwwv+an7013A6hvA3GyXKTxVzI0c7mg6CUX4RHl0JdUtUuEibl7yaHJKANQrY
	sfoNtKukyd5R0qYUnFCiFxmhMBVUE3qhkBh4TFl3MaFTV1RL2OfuYZ423tSWXHrbh2SiI7
	HmHqIv7Jx07xOw2GrVC1AFAIcvl9ClA=
From: Usama Arif <usama.arif@linux.dev>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 05/15] fs: afs: correctly drop reference count on mapping failure
Date: Fri, 13 Mar 2026 04:07:43 -0700
Message-ID: <20260313110745.2573005-1-usama.arif@linux.dev>
In-Reply-To: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D2EA64000B
X-Stat-Signature: tgt55m5jkpunr77hnzsbfpqb5uapfmxf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773400082-120582
X-HE-Meta: U2FsdGVkX18h0IlVmnh2kLZBuVMfyiJFi9+S1nkF1HjTYwXJzHEzRk9j185fQ1lZr6LwIQazdxJjBX0FbWEfT5eVjnzZ7NytnFSG3koo6NkEXNwaTyvjmdsEA2qjctr8rv0u1uMkwOyrwycznGQCD/Qw0RAVWKZ6rcpVnmh5M5E4hv+rz4pM7p2kx+rq6pQU+EwOsFjjnzxIgS/Z48ZdifstspFmQ0IUZHNKqvv1mgICVv0xkUmewaT9JVr/rfs1rcDhJTZy01GW9pP+8H+fYQC4/JlNUImcgEtHIxfHA1EEa1VmzIUO6QkuK0zgY2lo4BhG1ZeeyFlA+A35UZdLsOjDP5pt9eQgIeCN6qPYvXcSs3JbTR1P/nyUAMRdk3bIzU5OH7VjPTwJEYURkheDKTunn82/oSX4qRplWBPObEVVuqji3Da5UW7p5omiajHISvpUpcsqfQxOz+2Fs/8otpK28II6FeZhd9p3YEiTe3vIY8GIwO65F5OX9xGIzG4/FmHixV9qLdaXL+XHwYRSwQzBw9C7cth6xDLfKp7WiVcSbkgBGGA4a4Fs3yuk8TypL8Xi8GbUapLY5ocWCjCPReNeFAmUSh83rPNRS7XIDi4QPoBMd8aCE38hGm1kwP1gzYV7+bzIIVNXyjED8Z7omv398VCFaRkviSz/K0G4EerU5lxciGbODBCHbwsYA33htN8TcSXPe8/klyfLxSUU+SFdiRIvN56EOHUCG6qFFnb7D/5N6QN4qsvcft2o9hMj2MoAz2+jON2BOymj/L9VbxHMBJQtDXGm+IF4aZuNHmhZradgHz6ZTINdRN62spyKAcynCjxCo5C2a2TFpTFrCPD93pnOQNK5VLzK1UFO9Qi3xStv227MZ8kSMH1kZpyYYMMpRUGQuK4J0gz8+35+zk7EeYQC9aqtwolIL7a+LRpoyeqGUMHkZS9C94ntAA+2wtbc9G8xHeaGSn6uUJP
 zRnfPqd6
 lIQa6exdYdqZpMDYDOOq41XX2L5b9lNA1fP6XMN+tTfSkpxKEFBqzTrcYY15ffcQbPE4OS4F6FWqM+Z9jZc7GMf6/6eKlUHfkI0j27GrNYjYJQGmkvdd3AuZWniFr9lCdR8GxB5YaIPG7APJYCrw9D99gNIGDb8EQoxS/NErxQFdvgU3nS7P+xt22w21RdlImnpTiQfxeLSyaNcKKa3euqwlAmCHiNL4I5vZ3ATJJfFrIibDeIcyxf4tCoIL+CscyW4CVqCsn2pVi4dFLQYmDZezEeahLbryFgjxdTYyENASofbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour of
> the deprecated mmap callback.
> 
> However, it did not account for the fact that mmap_prepare can fail to map
> due to an out of memory error, and thus should not be incrementing a
> reference count on mmap_prepare.
> 
> With the newly added vm_ops->mapped callback available, we can simply defer
> this operation to that callback which is only invoked once the mapping is
> successfully in place (but not yet visible to userspace as the mmap and VMA
> write locks are held).
> 
> Therefore add afs_mapped() to implement this callback for AFS.
> 
> In practice the mapping allocations are 'too small to fail' so this is
> something that realistically should never happen in practice (or would do
> so in a case where the process is about to die anyway), but we should still
> handle this.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  fs/afs/file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index f609366fd2ac..69ef86f5e274 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
>  static void afs_vm_open(struct vm_area_struct *area);
>  static void afs_vm_close(struct vm_area_struct *area);
>  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
> +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +		      const struct file *file, void **vm_private_data);
>  
>  const struct file_operations afs_file_operations = {
>  	.open		= afs_open,
> @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
>  };
>  
>  static const struct vm_operations_struct afs_vm_ops = {
> +	.mapped		= afs_mapped,
>  	.open		= afs_vm_open,
>  	.close		= afs_vm_close,
>  	.fault		= filemap_fault,
> @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area_desc *desc)
>  	afs_add_open_mmap(vnode);

Is the above afs_add_open_mmap an additional one, which could cause a reference
leak? Does the above one need to be removed and only the one in afs_mapped()
needs to be kept?

>  
>  	ret = generic_file_mmap_prepare(desc);
> -	if (ret == 0)
> -		desc->vm_ops = &afs_vm_ops;
> -	else
> -		afs_drop_open_mmap(vnode);
> +	if (ret)
> +		return ret;
> +
> +	desc->vm_ops = &afs_vm_ops;
>  	return ret;
>  }
>  
> +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +		      const struct file *file, void **vm_private_data)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> +
> +	afs_add_open_mmap(vnode);
> +	return 0;
> +}
> +
>  static void afs_vm_open(struct vm_area_struct *vma)
>  {
>  	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> -- 
> 2.53.0
> 
> 

