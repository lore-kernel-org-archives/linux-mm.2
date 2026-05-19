Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA07CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50D36B0093; Mon, 18 May 2026 20:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01296B0095; Mon, 18 May 2026 20:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF06B6B0099; Mon, 18 May 2026 20:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8BDF6B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:35:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BF87120118
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:35:02 +0000 (UTC)
X-FDA: 84782299644.09.85445E1
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id E4FAB4000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:34:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779150900; a=rsa-sha256;
	cv=none;
	b=SvCNRnwMolR19xLXeYxLmPdZRK4EoWYZ5sgkn3XV3OI3NoCvi3iZCC4lNlnMYFGF1xa7NV
	iscORtml5W3MfOstTn3oZ5gAaVNGv+pCsGQHWHb1d7VRcRdgIeWxEZxKWuuYgdfgAZ/A9X
	0Ji0TQy9HQV6JBSCHExudK2tgMNDRZc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779150900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHNnIYKp7h/xkRLroIK+t3JNWtljMoVqvvNi1McsQsU=;
	b=ak6+qq5++ryQ8ju2dMRleVELTzEszB8na8ezLBEAirIjt8npM0UdF71h8Qqq391dA/d8oT
	+r61hRtqjxV6mhPjEExctAQM3+r4jRxtb+SfmfwVeJW6KMpmIDPi6fIuChW35G/cow9rKO
	lIpHbozvOoeXgKiOXCnLRSWapOZQ0wQ=
X-AuditID: a67dfc5b-c2dff70000001609-cb-6a0bb02fa827
Date: Tue, 19 May 2026 09:34:50 +0900
From: Byungchul Park <byungchul@sk.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, kernel_team@skhynix.com,
	ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
	kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
	sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
	edumazet@google.com, pabeni@redhat.com, david@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, kas@kernel.org, willy@infradead.org,
	baolin.wang@linux.alibaba.com, asml.silence@gmail.com,
	toke@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
Message-ID: <20260519003450.GA46041@system.software.com>
References: <20260515034701.17027-1-byungchul@sk.com>
 <agruFy80Ag3uIab0@lucifer>
 <20260518173119.f3348ec4cc66b793fed4cccf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518173119.f3348ec4cc66b793fed4cccf@linux-foundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+Z9zdnacLY7L6p9GH1ZRLLQSpTcSM7twSKLoApFRDT3kbF7a
	1JoUWI1Mc8uu5FqysMxWqcy8omZLZxfMey0tLaeZ4qUbI2dorgv17QfPw+95P7wMKckR+DCK
	uEReFSdXSmkRJRqZccNveZFnzIqubF8wFt6j4fa7cgEYzaUIvo13CWGq2obga10DDbk3nCQY
	m7QUDJS4EPTbeoVw17IFqtLKSOg994QGnXaChOrxUSGcLM8nwFicKoTmUr0ALrlukVDwzEpD
	W6WRhu57UwL4YNVRMOzYBJ8u15HQow8Fm2kOOJ8PI6grLCPAmXmdho7sSgIutppocGh7ELQ+
	7qXgzGAPBRPfpz3X6ruFoYu5x8NjJPfgzmuCs9c8I7gKw1shZ7IkccX5Mi7D3kpyFnM6zVm+
	XBByb15W0dyTqxMUV/F+NVdR/pXgdKdGaW6spoPmCh90UNu89oiCo3ilIplXLQ85IIpu/3Af
	JXyeebRGV4xSUbdnBvJgMBuI7efL6L+cOXmacjPFLsbG3MvIzTS7BNvt46SbvVk/bB6onGYR
	Q7J5NDZc+Sh0B7PY3dhYlPlLJGYBV/QP0e6ShL2I8KvOwT+BF36a3fdrgWRl2D45SGQgZpp9
	8e1Jxo0ebDgecUW4G7PZhbi2tIFwazBby+AXAy/J34fOw4/y7VQWYg3/WQ3/WQ3/rCZEmpFE
	EZccK1coA/2jNXGKo/6R8bEWNP01ecd/RJSjL807rIhlkHSGOHRKFCMRyJPVmlgrwgwp9RZP
	FnrESMRRck0Kr4rfr0pS8mor8mUo6VxxgPNIlIQ9KE/kD/F8Aq/6mxKMh08qmu0XdDhIpFwX
	5pUbtLRks8pqq90gOOdIz5qfsHFnSGv1Vsf32FONLh31OazFN8VVdS2yVq/VnBjfd6yvaVF4
	fXDaw+0tpx0FidmyR5JDeREpJn18qP++LI25cdnQqDk8a29H2M22nF3qNVrv/rN9rG19/6rg
	mPbOleTIWv2CgIQcKaWOlq+UkSq1/Cd1NIzAMQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA03SWUwTURQGYO/M9M5QKI616ASNDyWiIbJoNB7j1hf0usbEB9dEG51I2cRW
	CGgwRAgqUnCPlhJbUTZBsMhSFEIKshoXEK2goCgIBhUEWRWkRqNvX/Kf/5yXw9HyGIk7pwk9
	KmpD1cFKLGWkW1fGevvmOwf6mRtcwZiXgyHjbYkEjNlFCAZHW1mYLKtGMFBVgyHNPESD8Ukc
	Ax8LxxB0VnewcNuyBR6cKqahI7kWgz5unIay0S8snCzJpMBYEMNCZWqdBJ4WJUng0tgtGu7U
	2zA0lRoxtOVMSqDLpmeg9/066LtcRUN7kgqqTbNgqKEXQVVeMQVDiakYmq+VUnCx0YThfVw7
	gsbKDgZO97QzMD4ytSflYRur8iSVvV9pci/rFUXs5fUUsRresMRkCScFmV4kwd5IE0v2GUws
	3y6w5PWLB5jUXh1niPXdCmItGaCIPvYLJl/LmzFJ6+6jtsl3S1cdFIM1EaLWd81+acDzrlwU
	1u8aWa4vQDGozTkBOXECv1RInIhnHGb4+YIx7TJyGPMLBLt9lHZYwXsL2R9LpyzlaD4dC4Yr
	3awjmMnvFIz5idhhGQ+CtfMTdgzJ+YtIeNnS8yeYIdRd+/D7As17CfaJHioBcVOeI2RMcA46
	8ZuEz2N7HBNuvIdQUVRDnUMyw39lw39lw7+yCdHZSKEJjQhRa4KX+eiCAqJCNZE+Bw6HWNDU
	X6RH/zhfggab1tsQzyGli0w1KQ2US9QRuqgQGxI4WqmQTeQ5BcplB9VRx0Tt4X3a8GBRZ0Nz
	OEY5W7Zxh7hfzh9SHxWDRDFM1P5NKc7JPQbpupTPcgo6H632Pv5JN8OkqNU+PqKqu+G6PGdo
	2l3fn2XJCr9CfdNjbTxZcsmtukrSEuZ2U7V70y7/4ftylxObnwQVJqsXhSxvyUoZnkftnVsX
	uX1663E3O9MS7kGarVEKpXfmBtZzYa05+bu/JZfKTK/ov45HutamnzW7JBafjVYyugD1Yi9a
	q1P/Ap8yzS8TAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: qcsqshaeue3ubccok1ygsr63shrg9hwj
X-Rspam-User: 
X-Rspamd-Queue-Id: E4FAB4000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1779150899-153721
X-HE-Meta: U2FsdGVkX1/KlmQUmK3c7PX2UtZ5OHNBieMkrNya0c0nGaTRKcAilWoipZPc7Tx8uFfzHLROPyePRWAAd2R0Hw27IXQkNo6aQxSHLsRyttqB0qRgVADg+bB96VMxIdnLSLCkDCZFSWsjftzTh27+bkNiD/zsDiEYuBMnC43bhDgnMKxjvV4J5S2LWzFFbKksuX57e+LMuoQMX6GrPkNq+P+qZ/FUjQ0sgfDuwTlwg1tb8RSkldkA0e5VUJmO/XVM88FuCpswLQtBj34thKaoqrFAW6ylxcdn4HrTH2BAHPerTxGdN4fnfXfvzK2X+V9qRXS+IFeMX0ml0KGRSKH9ewmlKqTKyDkH/oX0DcjjGaTemVJMcKmkUuGRAuUI0wQWcKp4UZ8I+mp6cQHMgwcnKrM8U5/9hFLpjoE/FMVauWHdde2F5nUwP2wB+RS6R+zTW2LZKn9Y4OcKr9ki98STTu4Jzkhk9osM968ZPczey5LZX1KuO+t86UbadIPiYOD0o/DlT4gMUcjROP0SLB0Pyfpj5z367G9hO/P37+KrfF8DMpaCNWCfdFxz9GjkRD5jj82Ju/IOctsxLPwjpmBG39DkIS/7DapBNasyxDdXQguXfZiMAUDc4xFS4qW0BaSygT9UBB11MFo+Q4uLac5owgx7sJHQlLgB6FmiS0eKwYA/H8D7Q0rFShQUA+kyk48zbJUISVw2ZRARKFI/qoH4IErTuJ/rXQw62ThxbasmWFGA73dWejcHyW+hKoGMDoonYoKTkH1JVKfIeIP7oU5hWY+lgmH/zqVRdn3kxvUHXq0Y0rGfyR66COi4Xw+TXlQN+n6arwCVxaHthjXYuCh9FgzMcbdIWPyRSoYXxR/6c+xPSS8sA7rHB4mpAA5onGokUikgYEcxK5aOe7kNu4WVQ1Fw/f19ytb0h7DPdWXnBdU3rwIIVCvQrBfQxJlfToTr6upRMRLWsz1/J/XcNbN
 8QRDccQc
 9qh0qmRjpJw82ileErfud5/noDcSdCgP9X1tk8OoMlXoJTJO1JyTYX/xp3DJ+hvKfHg8y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 05:31:19PM -0700, Andrew Morton wrote:
> On Mon, 18 May 2026 12:00:11 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> 
> > Maybe worth putting [PATCH mm-hotfixes] just to make it clear this should be an
> > urgent hotfix?
> >
> > On Fri, May 15, 2026 at 12:47:01PM +0900, Byungchul Park wrote:
> > > This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> >
> > Maybe 'this reverts commit db359fccf212 ("...") and partially reverts commit
> > 735a309b4bfb9e ("...") <details>'?
> >
> > >
> > > Netpp page_type'ed pages might be used in mapping so as to use
> > > @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> > > struct page, these two can't be used at the same time.  Revert the
> > > commit introducing page_type for Netpp for now.
> >
> > Yikes!
> >
> > >
> > > The patch will be retried once @page_type and @_mapcount get allowed to
> > > be used at the same time.
> > >
> > > The revert also includes removal of @page_type initialization part
> > > introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> > > to initialize ->page_type"), which will be restored on the retry.
> >
> > As above maybe mentioning at top of commit msg, as right now this reads as a
> > pure revert of db359fccf212.
> 
> I did

Oh great!  Thanks.

	Byungchul

> : This reverts commit db359fccf212 ("mm: introduce a new page type for page
> : pool in page type") and a part of 735a309b4bfb9e ("net: add net_iov_init()
> : and use it > to initialize ->page_type").
> 
> > >
> > > Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> > > Closes: https://lore.kernel.org/all/982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com
> >
> > Fixes tag?
> 
> I assume db359fccf212 ("mm: introduce a new page type for page pool in
> page type") is close enough.  Both that and 735a309b4bfb9e are new in
> 7.1-rcX.

