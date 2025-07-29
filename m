Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EABC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 01:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2A56B007B; Mon, 28 Jul 2025 21:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C540A6B0088; Mon, 28 Jul 2025 21:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41BC6B0089; Mon, 28 Jul 2025 21:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0ECA6B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:09:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 549A214042B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:09:24 +0000 (UTC)
X-FDA: 83715519048.25.A78931F
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9D20D180007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:09:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753751362; a=rsa-sha256;
	cv=none;
	b=e04N1WUDMGmGys/wpCh8Umj6UBtYCROa25OhKiheloEeYBnubyig0Bws7aeowwJE5lljd4
	gWyBxSOh5jAxcI+iRsaO15rvYq/gSbW39UrzFQEfuAvTNy8Lzv5FaJi++7+qNYnmwt+14q
	mU82eUf/cS7A6lzgSANk4Gr9I/EEN08=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753751362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gEqcXYyy5ek8hWBx7PKZf+VNiZvCQg5oXkLdHiZ7dWI=;
	b=elyXP6Eg4ucz7H9FzHrO9jqrrQiPULD09nXhC7c8SSPq7hpYnd2GCpytwrRn4NOKGcNU2g
	1k7Urs5nS5Tj2uI0F/xmWNcO579vHnw3Gn5P+50Q2HWg20De+6AaHeS3a/+kO0s5WGtnRe
	7Su6um1TI8yAGkrJt5Pb3cDBQ5c2qeU=
X-AuditID: a67dfc5b-681ff7000002311f-05-68881e0fb1f4
Date: Tue, 29 Jul 2025 10:04:10 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
	saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
	mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
	pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	toke@redhat.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page
 pool in page type
Message-ID: <20250729010410.GC56089@system.software.com>
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
 <CAHS8izO6t0euQcNyhxXKPbrV7BZ1MfuMjrQiqKr-Y68t5XCGaA@mail.gmail.com>
 <da4a9efd-64b3-4dc5-a613-b73e17f160d6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da4a9efd-64b3-4dc5-a613-b73e17f160d6@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+fadnXMcGx2X1ZcGwSoKK7sZvd2FCL7+CKIiKimdeWgjN23L
	WxCsklzS7E41V6yrt9CYTrdKq2leKszMalnN0gyqaaYmmtJlSuR/D8/7Ps/v/ePlsfKJNJTX
	6veJBr06QcXKGFmn/MrcqKlmzfzCIh5sxTdZKBxIg9z3LinYCsoQ9A2+4eB3RQ2C3upaFr5W
	9SC4erkfg+1pBgM/in9i6Khp46DQsR5ab3xi4G5mOYa243UsWDKGMFQMdnFwyJUnAVuJiYPG
	smwpnPl5HUO56T0Hz2/bWPDd/C2FTx4LA/XWfAa6z1ZjaM2Oghr7ROh/7EdQXVwugf5jF1l4
	ceG2BE432Vloz2hF0FTVxsDZYTMLOQezEQwN/G3rOtEnhZyHPi4qnFb5v2Famv9aQr2VjyTU
	bX3HUbsjmZbkhdMsbxOmjoKjLHX0nOLo25d3WVp3foih7g9LqdvVK6GWw10s/d7RwtBvlS/Y
	DeO3y1bEiwnaFNEwb1WsTHPN1oKTLgenHTRtNaHP8iwUxBMhknR21EuzED+in91RBWxGmEFK
	T/q4gGaFmcTrHcQBHSLMJl9feUZ8LFzlyCVfaCA6XthBbt1bHrAVAhBnpp/NQjJeKbQh4vxw
	Do8Ogkn9hY/MaHYmGb7UhANZLISR3F/8qD2VHHbmjKwHCSvJvc6GEdQEYRq5X1YrCXQSwc8T
	93GXdPT8yeRBnpc5gYKtYxDWMQjrf4R1DMKOmAKk1OpTdGptQmSEJl2vTYvYlahzoL8/duPA
	cLQL9TRu8iCBRyq5QnM0U6OUqlOM6ToPIjxWhSiSrh/RKBXx6vT9oiExxpCcIBo9KIxnVJMU
	C/tT45XCbvU+cY8oJomGf1MJHxRqQlfOtXq2RKNVO0tjYsmSrQfOGLTr/C1F5m5z5LLzubO+
	x22bXueWR5sXJes25y9wr16stMylMX3+qF2xDRsLyn2vS1KNAxGKZiZsXu/CWrtuy9rUVw1r
	dhO1fm9qtzOZzpHHPdieZAlZMeWx/JY8DoaNXzLtRbi5tn2Ts3FcRruKMWrUC8Kxwaj+A1Z8
	W4FfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTcRjF++9/d+91trquVRfNglUISpZQ8ITa64f+RUnUhywKveatDafJ
	pqJBMFOyJM1ezJxTNFPzhazp1JllTFNX0MvEMis1UykyzTTJlKwpkd8O5zzn93w5LFbckbqz
	mqgYURclaFW0jJIF+SetW7zyvHrDWDIDpsoKGsp/xkNJb50UTGU1CMYn3zIw86AFwVhzKw1f
	mr4jKCyYwGB6nkzBj8pfGAZa+hgoN++DnuJBChpSajH0XWqjIS15CsODyWEGztbdloCpysBA
	U65dCi9q0qVw7VcRhlpDLwPt9SYauitmpDBoS6PAbiyl4FtmM4ae9G3Qkr8MJp4OIWiurJXA
	xMVcGjqy6yVw1ZFPw8fkHgSOpj4KMqfP05CTmI5g6udf2nDGuBRyHncz23xI09AIJtWlbySk
	8+ETCbEa3zMk3xxLqm57k9ROBybmsgs0MX+/wpB3rxpo0nZjiiLWD5uJtW5MQtKShmkyOtBF
	kZGHHfR+5RFZQLio1cSJuvVbQmXqW6YuHF3gFp9oCDagzwtTEcvy3Eb+5X1VKnJhKW4tX325
	m3FqmvPiOzsnsVMrOR/+y2vbrI+5QobP63Z3Vpdwx/i7jf5OW84Bb0kZolORjFVwfYi3fMjC
	c4Ebb8/up+a6Xvx0ngM7u5jz4Et+s3P2Kj7JkjN77sIF8o1fn82+Wsqt5h/VtEoy0CLjPJJx
	Hsn4n2ScR8pHVBlSaqLiIgWNdpOvPkKdEKWJ9z1+KtKM/q6o+Mz05To03r7LhjgWqRbK1RdS
	1AqpEKdPiLQhnsUqpTy66JxaIQ8XEk6LulMhulitqLchD5ZSLZfvOSSGKriTQowYIYrRou5f
	KmFd3A2o9VOaSnC94Tq5prQ+cve5PR8/b5db7nr6p99bfszuvT/pemDwgsBvJ+lRVOw5EbPC
	33LaviPFb9eLWFJ4lBv/6jq9M9RSrY0LSvyddbCW9TiwNSbTb2w0I6T95czZfnZksVVpL7L6
	7pC77T0shJWvXR1wYupefcnNyg4HExaQ7fJYRenVgp831umFP0DnRSdBAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 5b99nuqkhs1bz1mhongu5qr4nb6ht7bw
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D20D180007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753751361-207929
X-HE-Meta: U2FsdGVkX1/lK1qe/dBh2RNWruUIG1a3LTSeGRjIvBtjlh1c94gnn8frd9TklTqtL+9VRU4MuZs4NTQ6lYR4gi0Glbrc/sJaWoDJAyZnOCi321uuv1qhGUAPbHuwW27ok8G7hIuVD8QN2XJih8kei7uLXQEEn/fkT6Lawj0eSN/FVd3WTLzrvsBatxKCRJs2IBAJBvFZjvFE9/2uM3fr5owPCOIRl3EFljyapTyJXGTrBPPwF9O28hdL3+vkV4xx5OQG5zASEiUILPRS8NvihYXOA+m+w+SPZtnRlZcyJg83c+j22DtVrXy4ceC93UBFkb+afKtme0KI9HsMseTuxWI3xq/4so8+UVdIGFQRSJe+doTrH2utiyC457sN/nEIdrCUWg6c0SvT0kl7dJqb6PnXgHB6/FMFb55qfeXXUGlno7eDdcfMQ1cL79TtWwqhjeTg0Ovz8n9tO7Eng22/F25V0VDsIkg1wbBQOlewOOaCOaYEx6VLCGfbqLuECpsueWu65HePxxqSABt3lEppkeOBqXBCMt4mXR5LLh6FBxYM2BO82CG7m7qPyZb4zJqvY+FOYu3FcZqb3uJQJkRYfxTfK7xBRSCaIsmT+0ApioH311ErrZXtpt4kda52zoat7vH8Bfl2ufFpTb3QqvDRzHMVYBk6FBegqPcJGZkvhDSCV3pDi4Byq8u4IiB9yro2TEWa6lrT6VWkvRl6RQjOLMVhfj5HTIfxp/YJC1iVw48C2E8taGMVsBD65AKDlBK7EqPH0XCpfByN+JWzHjmFMbQl9ud/U5igyl46C+kOfxTZzKFr+5oO6qGGb919/IE9bKl5ndvgbLuWFvSBAlaJJ+FmZ+Mw520S7Y2dt0CYyK1yUS2B3xGuD6ev+rRO+Bpht8E9O8In3cuVGqo4UnMzNhX70sgY0sGXty1fh0xPQ3aZpacfMj7JGzgaJMAXb72omwaCi8Qxw+k8dHV4W0S
 8gXzf/3b
 9IA0EMYv7utQ30T5xoOS6eiKZZHnWgIKWpVYJGUjOI4DppYqIXB5B8PFUzpaI4z9CGuPRLa2AR6UOj/5Lp6iINaj6wioQQZEWBFGEYw+2drOlCfet8jhuJdK2As4LbcxDrdeah80EVaND/C8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 07:49:30PM +0100, Pavel Begunkov wrote:
> On 7/28/25 19:39, Mina Almasry wrote:
> > On Mon, Jul 28, 2025 at 11:35 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > > 
> > > On 7/28/25 06:27, Byungchul Park wrote:
> > > > Changes from v1:
> > > >        1. Rebase on linux-next.
> > > 
> > > net-next is closed, looks like until August 11.
> > > 
> > > >        2. Initialize net_iov->pp = NULL when allocating net_iov in
> > > >           net_devmem_bind_dmabuf() and io_zcrx_create_area().
> > > >        3. Use ->pp for net_iov to identify if it's pp rather than
> > > >           always consider net_iov as pp.
> > > >        4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> > > 
> > > Oops, looks you killed my suggested-by tag now. Since it's still
> > > pretty much my diff spliced with David's suggestions, maybe
> > > Co-developed-by sounds more appropriate. Even more so goes for
> > > the second patch getting rid of __netmem_clear_lsb().
> > > 
> > > Looks fine, just one comment below.
> > > 
> > > ...> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > > > index 100b75ab1e64..34634552cf74 100644
> > > > --- a/io_uring/zcrx.c
> > > > +++ b/io_uring/zcrx.c
> > > > @@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> > > >                area->freelist[i] = i;
> > > >                atomic_set(&area->user_refs[i], 0);
> > > >                niov->type = NET_IOV_IOURING;
> > > > +             niov->pp = NULL;
> > > 
> > > It's zero initialised, you don't need it.
> > > 
> > 
> > This may be my bad since I said we should check if it's 0 initialized.
> > 
> > It looks like on the devmem side as well we kvmalloc_array the niovs,
> > and if I'm checking through the helpers right, kvmalloc_array does
> > 0-initialize indeed.
> 
> I wouldn't rely on that, it's just for zcrx I do:
> 
> kvmalloc_array(...,  GFP_KERNEL | __GFP_ZERO);

For net_devmem_bind_dmabuf(), __GFP_ZERO will add bigger overhead than
just assignment, 'niov->pp = NULL'.

I'd like to ask you if you are still good with __GFP_ZERO overhead
before going ahead.

	Byungchul

> 
> --
> Pavel Begunkov

