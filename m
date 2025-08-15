Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A06CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28D78E01F3; Fri, 15 Aug 2025 09:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF7B8E01EC; Fri, 15 Aug 2025 09:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF9E8E01F3; Fri, 15 Aug 2025 09:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB9038E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:18:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52ED455202
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:18:15 +0000 (UTC)
X-FDA: 83779045350.30.DD4AD2C
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
	by imf10.hostedemail.com (Postfix) with ESMTP id A401CC0011
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:18:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=HlWIwWEB;
	spf=pass (imf10.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755263893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bb0W3QreuMWhX9jUJbsxnZFTBv+9eZ2r5LVq6jjWm9M=;
	b=W7N3u4h0ZyzwfFCIDoAJ0gNA7FkJoVigP+ga9lW1wvWJphvka8Pi8Au7bQLOlg2qkp27Pn
	8INH6Ov7Z1BvVkIKQcUpdneJ08BGKH2PzoF3diH1zDMhjybOx0dJPaj7uSR5wnlg+IIdI5
	6Ap+LUu53j8x+4HDITDU6zTNtLztDhM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=HlWIwWEB;
	spf=pass (imf10.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755263893; a=rsa-sha256;
	cv=none;
	b=X2qLZChBUiilEZ9iqjWXbFKpUUyz4cK0xAj7mBReLHc+qKfuaX3wtWkIh6psOyPq460DSR
	JuJE+c69cXZiXD4XBcFI2zmsV5NVQKyFSQOoTP8lz9fCzEy3LB07U5EVvml5aNsPCNTDVe
	x3RKuy0xEtgybUxdWr71FTn/zWsoK/M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=Bb0W3QreuMWhX9jUJbsxnZFTBv+9eZ2r5LVq6jjWm9M=; b=HlWIwWEBqPR/Zm0MJM4XZkTkcn
	nDFvNRBpr4AVclJ1HxMDZaB7lsHvPZ8SoSY6VcBFQJOaT/31N47M4wsp0DPwIOPun6/tN39n0qBBo
	pFkCEd2sUjq0EK8RWYLRZ7E37LKSb6m/5qGZmUs9SQ+LbdT86p5x87ps3DCn7OgJaKnDeen8fd137
	CcSm4grFuU1Uodx8rRhIeR//qeUeONx6M7p9SdWEyM7kNcODf4mK4JnVzKzkHRtICC71j0zI+97fF
	DnidqvSSuXHANejecsAWI/P78cNhci7FaeUAH29idc/mA+fxUd+cmkXdFuwakzEdZOhiha2NBjt6r
	YIFbh+OwiMvnp+Rz6di+bhtPusP8DQTUI19c76/uuQ8Xooycg83dOHlxluXvcE5D0Iek9QJduKP0d
	GMADli2B0dCcFOf4MRPQsbRS4mMl1+0+Xy83dEmrZkGy4k/57EVRetHYIFPUhbF61rko/0BvOao9V
	WZDQycmLblFJDpNhws04kiB/WA2uoXPpdT7vxz1DVzjcHUt6HRbsj8ImIJZGpA2CQgP2CPE1uZYv1
	DIUQ9PF+s5pXMe3LOkrGhcHkKA6dKniR1XQlv+Q1IthguKq1tnp8dlt4JzFtI5rdYXiw4ZxGBO91q
	Jg7hQvvdr7x+cVuGf7f9Ynjabc+0MY4qETQc5jXjQ=;
From: Christian Schoenebeck <linux_oss@crudebyte.com>
To: Harry Yoo <harry.yoo@oracle.com>,
 Dominique Martinet <asmadeus@codewreck.org>
Cc: syzbot <syzbot+3f9768ec54c86997ddfb@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
 david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 rakie.kim@sk.com, Eric Van Hensbergen <ericvh@kernel.org>,
 Latchesar Ionkov <lucho@ionkov.net>, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in alloc_frozen_pages_noprof
Date: Fri, 15 Aug 2025 15:17:45 +0200
Message-ID: <5288409.JjrPIszM2I@silver>
In-Reply-To: <aJwZPq0b2rckG-ap@codewreck.org>
References:
 <689bb893.050a0220.7f033.013b.GAE@google.com> <aJvc5m8Ocm3S_Xkc@hyeyoo>
 <aJwZPq0b2rckG-ap@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: A401CC0011
X-Rspam-User: 
X-Stat-Signature: numpkueqhzdw3xhejj5x6kjpbx3gad8u
X-Rspamd-Server: rspam09
X-HE-Tag: 1755263893-116634
X-HE-Meta: U2FsdGVkX19Eq49NvYcQUibhW5cIw7ALmg9Rvjm7yhmzxyVfDFjJcUWhBCOBMnxIc1JRF8vMUJJgzFWyunco8O44RWkSZdP2SC8tyZAoFX5JejnT82pb3zjbiPq5kBSxn30/MzI0teekBFHcdhD3AburGvUe7PE7i9BwoKUU7jcgzbKlaEoq28N0L7YXXOx7H9q7MsjlKlk4/Ud3DzJJTGmzXj619YF/7XixWQejcmGwdcM5aXzk1N6pxunnJoYnIR+/Lshew7lfpDZCTNzHcXNRED5jdWiv3i0B8bup1S6sqixKiewR1EDWQcvvQnRLcItekP4TXfKF7hjWImIC7gv97Q95bPA2MFZ96p7i0laVIrLuwBg4d9j1OuCILVQpx6jZxo2xfcOKrnELYP8trTFmdL4UMujpQx1ee0hJgNz3P+OrAmdAjpNo0/j4hDnM8zUTT6lSv/ou7wVYnTcPOVEUWje1cV8Wxri73eRjVJoofLndx+GW9gvfH9bh71/mN9LOZ8Nhb20uO/BuVd+pNcQv9wI7KURX3Oq5y5XMMaOK0VijqpiUjO9Lr2hhrNNlp+671SkQsGDvveqdU4a8eUE8AN0kshTdgVUmT9JoAiC5MNMRQhCjJT6d4Kqf5kXscWqFX256WnXwVbpxYw0FSEcTZ0v8Pc2c2XDE86jpTinXP7EMQ3QbzAdhBZboiEFSxYps8XkauRdbOMJ4WKwKL0ARIKVp6vEXitW4vkIaRABrySqwrNxVkOW+1CReqV+uE1EMOjR7XYk8SNe0KKvqA87fpsVFg241eaNhfPxNhlT14Gvj0vVpniQNWx858wJHaBigh7BUl7GaeYQcxaKV0SewR9VRH4NiESwYkpNWrFzquFU67puE7yUAQzH101q2SXO6rpZpidEQjvsC0RbzbW7pcIEAa9paa/TwE7WHeJ5ECcjgm4KNO2gsKXnfn5HZVEClmglXnlsJR7+n42R
 WuOxlbiF
 aVLJQ7SJETDANtdUulQ8Onk/U7sswjMDrFmZN7WLOVkVfxj1oLL7f3WAcKpn6aCxVYbeq/9mrvkoYgLvOXeyIgun6hXKswM3aynMwsq7tXVjVx5m8HDK5vlSboWMP5alpudJmWTjCjMrvHpyjv5BSNKUAwe19K4ICpQ11cpFNY06tICfRXS3T8SulO5Z3jjCx3QIUF0/BuW7tplXo3T66ms44k237AjSVD7UXiGHBWb5ftRN165fDCTFyV9fc8KuRr1/ZtskjMpSdCzJMCiOMeJh0LUaXATkvz6VA2IPjBkfcA7Q1CgGvNMC8bxkVxxx5LpJBxAsxajPEyS7kWSL3n2RVJIx3kYVM1LgGfRrM/cY0PKB16O4pRJfc2ZttPN4tkv+0CH85Tcv1Qy/7AGD5yPaMWdA1CwIhNSWC6M8vTUSPLcH5QVDwlaS1PyBWy4aiiCkM/2YLHwBGWY8pfI0IInEq2f/Br8jg8XAVE2b/W1c50gTdAUHa+g59OiBF8CRVvSNw/wYC13iFPagrQXslMlA9Q/QdBTlPF1uRueISSlTbLYHO/8MPo2zCXjUZmGGUB4xGQSwjP8ANeqN9tCfGX9o88f3lcjaBuhhKK8GEjE12uZ0R/bIUdIe6FWQmd+h0MH1YtOFRmMTwEj/6NYuZa+XUi6yf6dTNFxDhdoPRp833kpig4+vfIX53lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wednesday, August 13, 2025 6:49:02 AM CEST Dominique Martinet wrote:
> Harry Yoo wrote on Wed, Aug 13, 2025 at 09:31:34AM +0900:
> > The warning is:
> > 
> > 	/*
> > 	 * There are several places where we assume that the order value is sane
> > 	 * so bail out early if the request is out of bound.
> > 	 */
> > 	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
> > 		return NULL;
> > 
> > There's not much the buddy allocator can do when a user requests
> > order > MAX_PAGE_ORDER allocations.
> > 
> > >  alloc_pages_mpol+0x1e4/0x460 mm/mempolicy.c:2416
> > >  alloc_frozen_pages_noprof+0xe0/0x210 mm/mempolicy.c:2487
> > >  ___kmalloc_large_node+0xac/0x154 mm/slub.c:4306
> > >  __kmalloc_large_node_noprof+0x2c/0x8c mm/slub.c:4337
> > >  __do_kmalloc_node mm/slub.c:4353 [inline]
> > >  __kmalloc_noprof+0x3bc/0x4c8 mm/slub.c:4377
> > >  kmalloc_noprof include/linux/slab.h:909 [inline]
> > >  kzalloc_noprof include/linux/slab.h:1039 [inline]
> > >  v9fs_fid_get_acl+0x64/0x114 fs/9p/acl.c:32
> > 
> > So... 9p FS shouldn't really request that?
> > 
> > Cc'ing 9p FS folks.
> 
> Thanks for the Cc.
> 
> So, this comes up once in a while, everytime we discuss limiting the
> xattr size, then someone says we should do something else or I'm using
> the wrong define or I don't remember and then when I ask what we should
> do never reply again.
> 
> See [1] or [2] for the last two time this happened.
> [1] https://lore.kernel.org/all/20240304-xattr_maxsize-v1-1-322357ec6bdf@codewreck.org/T/#u
> [2] https://lore.kernel.org/lkml/20240202121319.21743-1-pchelkin@ispras.ru/
> 
> I'll be happy to take any patch you send (or one of the older patches if
> you tell me which is "correct"), I don't care anymore.
> 

Not that I would care much either, but as nobody else responded, I still think
the following is the way to go:

diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index 8604e3377ee7..97f60b73bf16 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -37,8 +37,8 @@ ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
 	if (attr_size > buffer_size) {
 		if (buffer_size)
 			retval = -ERANGE;
-		else if (attr_size > SSIZE_MAX)
-			retval = -EOVERFLOW;
+		else if (attr_size > KMALLOC_MAX_SIZE)
+			retval = -E2BIG;
 		else /* request to get the attr_size */
 			retval = attr_size;
 	} else {

---

Values > KMALLOC_MAX_SIZE are triggering the reported warning.

XATTR_SIZE_MAX (64k) would be much smaller than KMALLOC_MAX_SIZE (4M).

The call stack in question comes from ACL handling. In this case there is no 
XATTR_SIZE_MAX limit involved on 9p client side. If 9p server side does,
then server responds with an error anyway. If however server does not have
this limit then why limiting it to XATTR_SIZE_MAX on client side for all?

And if OTOH the call stack comes from the general purpose xattr API (i.e. not
ACL stuff), then there is already a XATTR_SIZE_MAX check on xattr VFS layer.
So no need to check for XATTR_SIZE_MAX on 9p layer for a 2nd time:

https://github.com/torvalds/linux/blob/d7ee5bdce7892643409dea7266c34977e651b479/fs/xattr.c#L616

In the end it is merely a theoretical issue. POSIX ACLs are quite compact
encoded into xattrs. To fill 64k you need a ridiculous large set of ACLs.

/Christian



