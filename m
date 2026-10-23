Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED0E606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jsUFE5Oz
Received: by kanga.kvack.org (Postfix)
	id A8E316B0332; Thu, 22 Oct 2026 23:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63D86B0333; Thu, 22 Oct 2026 23:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B806B0334; Thu, 22 Oct 2026 23:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF9A6B0332
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:32:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B109014022B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:32:14 +0000 (UTC)
X-FDA: 85352467788.22.ED3F7BE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8653C0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:32:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jsUFE5Oz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of baoli.zhang@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=baoli.zhang@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792726332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pwHfNPbqvBqUhaj6DewmHXKCkUPNB2UvmSyj2WSSUI=;
	b=NanCKAwcczy8zbCR7khvjry5Dk2xq2yfAJlug/HVFiGaGiOYa+y/slfILtwzYlZ2iG78Fw
	21nn/AdPqwFArezdKiuSH7S3WN3kcV1bj8zZ4BbbO0XC6UmIdyMiUEjnWsoJZAgmDr6wDi
	WJj62DhadQOQMeknB2ziU+2oSg9AV/E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jsUFE5Oz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of baoli.zhang@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=baoli.zhang@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792726332;
	b=ym2ZyY3wCxxcG3AEozL8w+tUfvRw9v+mHYbmUOfbBHL/AwxhfUDViYeUKqKGTOU8EZfaO8
	SHPKSH4/Hx0L9LAf3k7jZFZ14z0UXQ2NyZSQS6WsQWNfTfg39x3eYTP28Cpg2rx6Jkge7S
	P6g0yoc+7p+/OoNqNO/wnMeOqBmYN9s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792726332; x=1824262332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=B9jGSLiQCskbtTSWWbfDi/DlirPciMB56roEIhZBqgA=;
  b=jsUFE5OzC3i4YV3T/sN9ZPCfD/zVRKs1spa9HOfJJ4pIx24HxwNuFugE
   5+qeFpQ1xLnerdnt/lCdZvy5u2DALh4h9tw83A/dYLHEUzJ709Jdj7lSt
   2YyoIr3iSJSLcdjQwlUS/xcmY3FxCB5r0rmfFxIpHdoVzQeFcAJiIW7Zt
   N2NRfuVFQwkGCKUKCjKLCdzKEXOBZsbqfz5f5aGzPIh3U0AYYDa7pwKhk
   qHor6Du3FxI66pICQMkJ7+2nqbp+YoqT2Xp5pDFSPv1BlsjiR6liV4gwa
   Ti/eZnn60Iw/Zm8+04ueiRNulwP/o9tywnVYW5k7HmxI8jn/vbtKNMS/4
   g==;
X-CSE-ConnectionGUID: sP6f4FixTpybv4rTmbO74g==
X-CSE-MsgGUID: 52Si2qVpT7OvZl5InUdRhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1494792"
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208,217";a="1494792"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 20:32:11 -0700
X-CSE-ConnectionGUID: o3ISNXllQaehpo9y5kCyhQ==
X-CSE-MsgGUID: TXOfS6XDRsiD4n3zA7kj/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208,217";a="5286303"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 20:32:10 -0700
Received: from [10.238.144.110] (unknown [10.238.144.110])
	by linux.intel.com (Postfix) with ESMTP id B2DA520B5708;
	Thu, 22 Oct 2026 20:32:08 -0700 (PDT)
Content-Type: multipart/alternative;
 boundary="------------buBCf84Cr0pGZ0hVo0MkgPTi"
Message-ID: <c648e9bb-d398-4d15-91e7-dd9b21f54793@linux.intel.com>
Date: Fri, 23 Oct 2026 11:32:07 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xarray: initialise the offset of a new root node
To: Nickolai Zeldovich <nickolai@csail.mit.edu>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261012181107.772545-1-nickolai@csail.mit.edu>
Content-Language: en-US
From: "Zhang, Baoli" <baoli.zhang@linux.intel.com>
In-Reply-To: <20261012181107.772545-1-nickolai@csail.mit.edu>
X-Rspamd-Queue-Id: B8653C0005
X-Stat-Signature: 917fnryj8dpggidbk3oykba8nx9jrxz6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792726331-89895
X-HE-Meta: U2FsdGVkX1+hsJ1e/q44YfwZ54CjXP6NVQNtDgx9YRHiQ+TOLgF3R3tp3lrXSapkDZ4VzBTmVMfPmmyLe7cR8sqjYnBzUXiE86pM0XK9mbTBvxf7Xis9yNxoiRdJhie66ytUHZvERLXE3w879M3daY9hyyD6XQMZB01xY0JM8awGqXyWxPgfFBOOnblhyond2jfpWIwdxLQWklTURBs/1+qhp/8zRrhRkNWFXSU8KEAzldS2A24PU72p0cu1DnXCQH9WDWGEM8fw91n/0jNnyv8KpI+9dX0CWJo5zNN0lYssoyrDBhURQYuRPC9gVaiL+jELP9C+fPGM2kGO3IRfY+VkHbUpDDFIa7FdJt5wR02fvrn4yp3tVZo4eRR9GxjwyM458pYyd+m75Ke/vOf55O/qx00y7NtkuYACiB2dBzDVTwsAtiUSxVCP3L25+Q/SHFdSv0iJMp9spZf1jOLrcMahTp4IFIDBOc8iwWyD9rnNO3NQ0AACZFmEH7EzHvc2j9AwzdB64JLrlWytZWQiqoI05p0FG7OgsUp2oRKNsjEtKWjLuo2vC+CCRBnZH/dj1LfzJ5Q6HBscBHuRHXZNak5yS2ZepPToJeZebCMcux28xmx0saSKmkhpgLHCpHtoluBFlh2VK7oe8UalJLJG9LAS28iToPmewK7WEGUZD3u9/jaBgQ4/K0uZHwR8spMuvBEkKSqWj/FK0QNCC3h6Cgxro0/1yoHJEW/6kyL3PFnsjYNjScDtL+vbZd0zCTRAO19M+4gR6t5iNxI2Bj/zdekH1W462nMK42o0jTJ3aaTC+AgAmGHZ0Wxz8l1h97K21cJpyYzVHWdQ0Fvqoim0/IGxwnFWnD1x7mOkGVfiweHipLYC3Bj0K5GDY8Dv6OJrVQLBuKntPcgXlP3ssTb/rsp68GVKgbKAKBY1+6GwmraVQ2iJoviNEDgwSNmBeV6sTx8XpchQzGD3rBoGLaa
 9Wy9ljoi
 PIvBxdJkZnsFI/FwiSslCThEGbnL0x84Bblyzf+lV8/aDKqunv6n1sH3SRb0akoWMOMVJ1uUocwXCrtSe46kOOKoU4lTLpTs9KoEV2gmbiQKKhmRBnc7T6FR3wrAvGCLbmR4vgdNWw3fpdZN/CevbxA7NTxCQ76Saz7K+fQV8KFIoQ88He/oMK4kEWDoqNwb8j3SPZ7+AhXWyo/gUKbbtaSEYTg+BgWhngpWbg3TUNizjJpsfhf28vLJRfESGgZ079UIsIqRClJl8lCxOUvZ8lBy43XC4t9kRqSZJo6/b5VRxZyzPS69zh9Zt7kMKjuGKkY/xUBI2gCJXVwfS0E847zYqszUGS7rxfuv72e7TFV9Wud/2LJr9VfVqWwDfV5w2dOXlELYIsgw27+SEwjdSwmUbAvgep+8t+as0paCThMxB3/yDg0q4kgc4tPvvLHhDTfp1LuhT/79BeX1l2xzrpfaT2LrbyQVt2e5N7wLEN556Y2YVeuYw14ZkmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a multi-part message in MIME format.
--------------buBCf84Cr0pGZ0hVo0MkgPTi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I believe this patch can fix KCSAN: data-race in xas_create / xas_find 
(10)  . <https://syzkaller.appspot.com/bug?extid=73641b60a3bc11dfca8c>

And I have already tested it as below locally.

      - The userspace tools/testing/radix-tree suite, built with ASAN and
        UBSAN, passes.
      - Checking the offset of the root after every random store/erase finds
        a non-zero value in about 35% of the checks without this change and
        in none with it.

Futhermore,  it's better to add below changes in the same file:

@@ -616,10 +622,8 @@ static int xas_expand(struct xa_state *xas, void *head)
                  * Now that the new node is fully initialised, we can add
                  * it to the tree
                  */
-               if (xa_is_node(head)) {
-                       xa_to_node(head)->offset = 0;
+               if (xa_is_node(head))
rcu_assign_pointer(xa_to_node(head)->parent, node);
-               }


Tested-by: Baoli Zhang <baoli.zhang@intel.com>

BR/Baoli

On 10/13/2026 2:11 AM, Nickolai Zeldovich wrote:
> xas_alloc() sets node->offset only when the new node has a parent.  A
> root node, allocated by xas_create() for an empty array or by
> xas_expand() when the tree grows, keeps the offset its slab object had
> before: radix_tree_node_cachep has a constructor, so the slab does not
> clear the object, and radix_tree_node_rcu_free() only clears the slots
> and marks.  A node freed from slot N of its parent comes back as a root
> with offset N.
>
> xas_expand() stores 0 to the old root's offset just before publishing it
> as slot 0 of the new root, so the value is right once the expansion is
> visible, but an RCU walker can see the old value.  The iterators climb
> out of a node with
>
> 	xas->xa_offset = xas->xa_node->offset + 1;
> 	xas->xa_node = xa_parent(xas->xa, xas->xa_node);
>
> (xas_find(), xas_find_marked() and __xas_next(); __xas_prev() uses
> "- 1").  A walker under rcu_read_lock() that reaches the end of the root
> while another thread expands the tree can load the stale offset before
> xas_expand() clears it and the parent pointer after xas_expand() sets
> it.  No reordering is needed: the two loads only have to straddle the
> two stores.  The walker then continues in the new root at slot
> (stale offset + 1) while xa_index is the first index of slot 1.  If that
> slot is populated by then (for example by the store that caused the
> expansion), the walker returns its entry with the wrong index.  With a
> root covering 0-63 and a stale offset of 5, xa_for_each() that runs
> concurrently with xa_store(xa, 384, p) can report p at index 64, and
> then again at 384; xa_find() stores the wrong index in *indexp.  Any
> entries in slots 1..5 of the new root are skipped.
>
> The radix tree's radix_tree_node_alloc() always sets the offset, and
> radix_tree_extend() passes 0 for a new root.  xas_alloc() dropped this
> for root nodes when the XArray was introduced.
>
> Set the offset of a node allocated without a parent to 0.  A node's
> offset then never changes while readers can see it: a child's offset is
> set before the node is published, xas_expand()'s store to the old root
> writes the value it already has, and the root that xas_shrink() leaves
> behind was the child in slot 0.  A walker climbing out of a root
> continues at slot 1 whichever parent pointer it loads.
>
> The new test frees two nodes with non-zero offsets and checks that the
> roots created by xas_create() and xas_expand() have offset 0.  Its
> checks use a new XA_WARN_ON(), which warns and carries on, counted like
> XA_BUG_ON().  The test relies on the slab handing the freed nodes back;
> without this patch both checks fail in the userspace harness and in the
> self-test booted on x86_64 and riscv64 under QEMU.  The race itself has
> no deterministic test.
>
> Found while formally verifying the lockless XArray iterators against the
> kernel binary.
>
> Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
> Cc:stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich<nickolai@csail.mit.edu>
> ---
>
> Notes:
>      - The patch and its analysis were drafted with an LLM coding assistant
>        and then reviewed and tested as described here and in the commit
>        message.
>      
>      - Reproduction of the race (test build only, not part of this patch): in
>        tools/testing/radix-tree (XA_CHUNK_SHIFT 3), a hook between the two
>        loads of the climb in xas_find() runs the expanding store, i.e. the
>        writer runs after the walker loaded the root's offset and before it
>        loaded the parent.  The root was reallocated from a leaf freed at
>        offset 5.  Without this patch xa_for_each() prints "index 8 entry 48",
>        then "index 48 entry 48"; with it, only "index 48 entry 48".  Nothing
>        was reproduced without the injected hook: the window is two loads wide.
>      
>   lib/test_xarray.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
>   lib/xarray.c      |  2 ++
>   2 files changed, 52 insertions(+)
>
> diff --git a/lib/test_xarray.c b/lib/test_xarray.c
> index 5ca0aefee9aa..27988441e71c 100644
> --- a/lib/test_xarray.c
> +++ b/lib/test_xarray.c
> @@ -32,6 +32,22 @@ void xa_dump(const struct xarray *xa) { }
>   } while (0)
>   #endif
>   
> +/*
> + * Warn if @x holds and return whether it did, so that the caller can skip
> + * checks which would not terminate or would not mean anything on the
> + * broken state.  Counted with tests_run and tests_passed like the rest.
> + */
> +#define XA_WARN_ON(xa, x) ({					\
> +	bool __failed = WARN_ON(x);				\
> +								\
> +	tests_run++;						\
> +	if (__failed)						\
> +		xa_dump(xa);					\
> +	else							\
> +		tests_passed++;					\
> +	__failed;						\
> +})
> +
>   static void *xa_mk_index(unsigned long index)
>   {
>   	return xa_mk_value(index & LONG_MAX);
> @@ -370,6 +386,39 @@ static noinline void check_xa_shrink(struct xarray *xa)
>   	}
>   }
>   
> +static noinline void check_xa_root_offset(struct xarray *xa)
> +{
> +	DEFINE_XARRAY(tmp);
> +	struct xa_node *node;
> +
> +	/* Free two nodes with non-zero offsets so the slab can reuse them */
> +	xa_store_index(&tmp, 0, GFP_KERNEL);
> +	xa_store_index(&tmp, 5UL << XA_CHUNK_SHIFT, GFP_KERNEL);
> +	xa_store_index(&tmp, 6UL << XA_CHUNK_SHIFT, GFP_KERNEL);
> +	xa_store_index(&tmp, 7UL << XA_CHUNK_SHIFT, GFP_KERNEL);
> +	xa_erase_index(&tmp, 5UL << XA_CHUNK_SHIFT);
> +	xa_erase_index(&tmp, 6UL << XA_CHUNK_SHIFT);
> +	rcu_barrier();
> +
> +	/* A root created by xas_create() must have offset 0 */
> +	XA_WARN_ON(xa, xa_store_index(xa, 0, GFP_KERNEL));
> +	XA_WARN_ON(xa, xa_store_index(xa, 1, GFP_KERNEL));
> +	rcu_read_lock();
> +	node = xa_to_node(xa_head(xa));
> +	XA_WARN_ON(xa, node->offset != 0);
> +	rcu_read_unlock();
> +
> +	/* And so must a root created by xas_expand() */
> +	XA_WARN_ON(xa, xa_store_index(xa, XA_CHUNK_SIZE, GFP_KERNEL));
> +	rcu_read_lock();
> +	node = xa_to_node(xa_head(xa));
> +	XA_WARN_ON(xa, node->offset != 0);
> +	rcu_read_unlock();
> +
> +	xa_destroy(xa);
> +	xa_destroy(&tmp);
> +}
> +
>   static noinline void check_insert(struct xarray *xa)
>   {
>   	unsigned long i;
> @@ -2235,6 +2284,7 @@ static int xarray_checks(void)
>   	check_xa_load(&array);
>   	check_xa_mark(&array);
>   	check_xa_shrink(&array);
> +	check_xa_root_offset(&array);
>   	check_xas_erase(&array);
>   	check_insert(&array);
>   	check_cmpxchg(&array);
> diff --git a/lib/xarray.c b/lib/xarray.c
> index bfe7bef80f34..720d46e8b14a 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -387,6 +387,8 @@ static void *xas_alloc(struct xa_state *xas, unsigned int shift)
>   		parent->count++;
>   		XA_NODE_BUG_ON(node, parent->count > XA_CHUNK_SIZE);
>   		xas_update(xas, parent);
> +	} else {
> +		node->offset = 0;
>   	}
>   	XA_NODE_BUG_ON(node, shift > BITS_PER_LONG);
>   	XA_NODE_BUG_ON(node, !list_empty(&node->private_list));
>
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
--------------buBCf84Cr0pGZ0hVo0MkgPTi
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hi,</p>
    <p>I believe this patch can fix <a
href="https://syzkaller.appspot.com/bug?extid=73641b60a3bc11dfca8c">KCSAN:
        data-race in xas_create / xas_find (10)  .</a>  </p>
    <p>And I have already tested it as below locally. </p>
    <p>     - The userspace tools/testing/radix-tree suite, built with
      ASAN and<br>
             UBSAN, passes.<br>
           - Checking the offset of the root after every random
      store/erase finds<br>
             a non-zero value in about 35% of the checks without this
      change and<br>
             in none with it.</p>
    <p>Futhermore,  it's better to add below changes in the same file:</p>
    <p>@@ -616,10 +622,8 @@ static int xas_expand(struct xa_state *xas,
      void *head)<br>
                       * Now that the new node is fully initialised, we
      can add<br>
                       * it to the tree<br>
                       */<br>
      -               if (xa_is_node(head)) {<br>
      -                       xa_to_node(head)-&gt;offset = 0;<br>
      +               if (xa_is_node(head))<br>
                             
      rcu_assign_pointer(xa_to_node(head)-&gt;parent, node);<br>
      -               }<br>
      <br>
    </p>
    <p><br>
    </p>
    <p>Tested-by: Baoli Zhang <a class="moz-txt-link-rfc2396E" href="mailto:baoli.zhang@intel.com">&lt;baoli.zhang@intel.com&gt;</a></p>
    <p>BR/Baoli</p>
    <div class="moz-cite-prefix">On 10/13/2026 2:11 AM, Nickolai
      Zeldovich wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20261012181107.772545-1-nickolai@csail.mit.edu">
      <pre wrap="" class="moz-quote-pre">xas_alloc() sets node-&gt;offset only when the new node has a parent.  A
root node, allocated by xas_create() for an empty array or by
xas_expand() when the tree grows, keeps the offset its slab object had
before: radix_tree_node_cachep has a constructor, so the slab does not
clear the object, and radix_tree_node_rcu_free() only clears the slots
and marks.  A node freed from slot N of its parent comes back as a root
with offset N.

xas_expand() stores 0 to the old root's offset just before publishing it
as slot 0 of the new root, so the value is right once the expansion is
visible, but an RCU walker can see the old value.  The iterators climb
out of a node with

	xas-&gt;xa_offset = xas-&gt;xa_node-&gt;offset + 1;
	xas-&gt;xa_node = xa_parent(xas-&gt;xa, xas-&gt;xa_node);

(xas_find(), xas_find_marked() and __xas_next(); __xas_prev() uses
"- 1").  A walker under rcu_read_lock() that reaches the end of the root
while another thread expands the tree can load the stale offset before
xas_expand() clears it and the parent pointer after xas_expand() sets
it.  No reordering is needed: the two loads only have to straddle the
two stores.  The walker then continues in the new root at slot
(stale offset + 1) while xa_index is the first index of slot 1.  If that
slot is populated by then (for example by the store that caused the
expansion), the walker returns its entry with the wrong index.  With a
root covering 0-63 and a stale offset of 5, xa_for_each() that runs
concurrently with xa_store(xa, 384, p) can report p at index 64, and
then again at 384; xa_find() stores the wrong index in *indexp.  Any
entries in slots 1..5 of the new root are skipped.

The radix tree's radix_tree_node_alloc() always sets the offset, and
radix_tree_extend() passes 0 for a new root.  xas_alloc() dropped this
for root nodes when the XArray was introduced.

Set the offset of a node allocated without a parent to 0.  A node's
offset then never changes while readers can see it: a child's offset is
set before the node is published, xas_expand()'s store to the old root
writes the value it already has, and the root that xas_shrink() leaves
behind was the child in slot 0.  A walker climbing out of a root
continues at slot 1 whichever parent pointer it loads.

The new test frees two nodes with non-zero offsets and checks that the
roots created by xas_create() and xas_expand() have offset 0.  Its
checks use a new XA_WARN_ON(), which warns and carries on, counted like
XA_BUG_ON().  The test relies on the slab handing the freed nodes back;
without this patch both checks fail in the userspace harness and in the
self-test booted on x86_64 and riscv64 under QEMU.  The race itself has
no deterministic test.

Found while formally verifying the lockless XArray iterators against the
kernel binary.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Cc: <a class="moz-txt-link-abbreviated" href="mailto:stable@vger.kernel.org">stable@vger.kernel.org</a>
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <a class="moz-txt-link-rfc2396E" href="mailto:nickolai@csail.mit.edu">&lt;nickolai@csail.mit.edu&gt;</a>
---

Notes:
    - The patch and its analysis were drafted with an LLM coding assistant
      and then reviewed and tested as described here and in the commit
      message.
    
    - Reproduction of the race (test build only, not part of this patch): in
      tools/testing/radix-tree (XA_CHUNK_SHIFT 3), a hook between the two
      loads of the climb in xas_find() runs the expanding store, i.e. the
      writer runs after the walker loaded the root's offset and before it
      loaded the parent.  The root was reallocated from a leaf freed at
      offset 5.  Without this patch xa_for_each() prints "index 8 entry 48",
      then "index 48 entry 48"; with it, only "index 48 entry 48".  Nothing
      was reproduced without the injected hook: the window is two loads wide.
    
 lib/test_xarray.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |  2 ++
 2 files changed, 52 insertions(+)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee9aa..27988441e71c 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -32,6 +32,22 @@ void xa_dump(const struct xarray *xa) { }
 } while (0)
 #endif
 
+/*
+ * Warn if @x holds and return whether it did, so that the caller can skip
+ * checks which would not terminate or would not mean anything on the
+ * broken state.  Counted with tests_run and tests_passed like the rest.
+ */
+#define XA_WARN_ON(xa, x) ({					\
+	bool __failed = WARN_ON(x);				\
+								\
+	tests_run++;						\
+	if (__failed)						\
+		xa_dump(xa);					\
+	else							\
+		tests_passed++;					\
+	__failed;						\
+})
+
 static void *xa_mk_index(unsigned long index)
 {
 	return xa_mk_value(index &amp; LONG_MAX);
@@ -370,6 +386,39 @@ static noinline void check_xa_shrink(struct xarray *xa)
 	}
 }
 
+static noinline void check_xa_root_offset(struct xarray *xa)
+{
+	DEFINE_XARRAY(tmp);
+	struct xa_node *node;
+
+	/* Free two nodes with non-zero offsets so the slab can reuse them */
+	xa_store_index(&amp;tmp, 0, GFP_KERNEL);
+	xa_store_index(&amp;tmp, 5UL &lt;&lt; XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_store_index(&amp;tmp, 6UL &lt;&lt; XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_store_index(&amp;tmp, 7UL &lt;&lt; XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_erase_index(&amp;tmp, 5UL &lt;&lt; XA_CHUNK_SHIFT);
+	xa_erase_index(&amp;tmp, 6UL &lt;&lt; XA_CHUNK_SHIFT);
+	rcu_barrier();
+
+	/* A root created by xas_create() must have offset 0 */
+	XA_WARN_ON(xa, xa_store_index(xa, 0, GFP_KERNEL));
+	XA_WARN_ON(xa, xa_store_index(xa, 1, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_WARN_ON(xa, node-&gt;offset != 0);
+	rcu_read_unlock();
+
+	/* And so must a root created by xas_expand() */
+	XA_WARN_ON(xa, xa_store_index(xa, XA_CHUNK_SIZE, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_WARN_ON(xa, node-&gt;offset != 0);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	xa_destroy(&amp;tmp);
+}
+
 static noinline void check_insert(struct xarray *xa)
 {
 	unsigned long i;
@@ -2235,6 +2284,7 @@ static int xarray_checks(void)
 	check_xa_load(&amp;array);
 	check_xa_mark(&amp;array);
 	check_xa_shrink(&amp;array);
+	check_xa_root_offset(&amp;array);
 	check_xas_erase(&amp;array);
 	check_insert(&amp;array);
 	check_cmpxchg(&amp;array);
diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34..720d46e8b14a 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -387,6 +387,8 @@ static void *xas_alloc(struct xa_state *xas, unsigned int shift)
 		parent-&gt;count++;
 		XA_NODE_BUG_ON(node, parent-&gt;count &gt; XA_CHUNK_SIZE);
 		xas_update(xas, parent);
+	} else {
+		node-&gt;offset = 0;
 	}
 	XA_NODE_BUG_ON(node, shift &gt; BITS_PER_LONG);
 	XA_NODE_BUG_ON(node, !list_empty(&amp;node-&gt;private_list));

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
</pre>
    </blockquote>
  </body>
</html>

--------------buBCf84Cr0pGZ0hVo0MkgPTi--

