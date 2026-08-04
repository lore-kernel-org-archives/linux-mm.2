Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403BFC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E32C6B0101; Tue,  4 Aug 2026 12:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494416B0102; Tue,  4 Aug 2026 12:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AAF96B0103; Tue,  4 Aug 2026 12:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6AF6B0101
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:33:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3F15A01DA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:33:27 +0000 (UTC)
X-FDA: 85064132454.17.5276EC3
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id E138A10000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:33:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785861205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EuQKo8U/3LIocjDTexE8DH7FKZtl866bQ808xDyWb/E=;
	b=TnaE+2cRtIHVGiuGXAloqjg4tkev1zd8+CiCBH6UX3J1DzX071H/CCcj5HIQF+gyx/riXt
	tGQS5FL5n6HQhCqCOdAJcWssPtwLlvjdmus4afcHkR+LA5C46i/AAeEsBYF+ucQKN70QXZ
	Wy3JzvAweztvetRu4Hf4+gOiTcrheCw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785861205;
	b=HmacuiLHaF08BcjP+DFQ2oqtwakSnsv7rU3piFxYQxwXmQdixuSIkO/J7fGuZP7QvBLydE
	NUBvqyrGQMfb2GdC4ZMPZyTNZ43HEetk9cT5IApoEwBlRiSg6gdJYLE1V845hO0OV9aFpB
	+tBQQ6N4nkyrG0YtgdHDwQW5iklti5w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
	by 156.147.23.52 with ESMTP; 5 Aug 2026 01:33:21 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.151 with ESMTP; 5 Aug 2026 01:33:20 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 5 Aug 2026 01:33:20 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/swap: fix stale comment on
 swap_info_struct::cluster_info
Message-ID: <anIUUOCkwf85DFVJ@yjaykim-PowerEdge-T330>
References: <20260728155907.391820-1-youngjun.park@lge.com>
 <20260728155907.391820-2-youngjun.park@lge.com>
 <CAGsJ_4wvWMm4O=OBCQgpT=OWudgZ5D8E0Ri_B7xS6+6nQX7vjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wvWMm4O=OBCQgpT=OWudgZ5D8E0Ri_B7xS6+6nQX7vjg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E138A10000B
X-Stat-Signature: fm6ue8qy9fqxzm7oqm6gyxw87qkrx8oq
X-HE-Tag: 1785861204-54265
X-HE-Meta: U2FsdGVkX1/aYzSWbREMnuFp2HtS1hNIQhaUh8p/K7W8LAGNYX9nLzJjUDLux0BRxigX2OY2EzWvnrGEcGZrozNNEeeHX0WtOImb36Qt5V3cruBUQdf+JATgXZiwuJQgllyZ9zcXaXv0BAUyj+oEUDms6CurmWcLpk7j7shQPbizKr+6ubbioVX51rOOKOaJ3r/95rCap00MusY8d0vjNiOCyk5JqX2UYycbTSL6qydlEMqjibHSwyVmPUXl9l817MdgsBUyjp93qxG4Eu5HgfUtGnLb1rZL5TEKdsGvXMHZgU1n+ZP4h5pZ3WNQU+S3UhLo4yOvv0nSH4VrYwLd4FpqHh68U1ErmAOdkbx8Wx2D11hUjLze69MHu66kFL2ivOpb36OOFiMU1rCsL1KRFb9t3qYf1ii2s0Ly3fuvTQS4Zzg2z+Ylevj8atTgSRknhBq55Q7wEO4QP6IMy4aWE9EGkhVaQsy0KapoqWEd+DCc62dzggqDR0YRuqLPUJiS/01gv/zi5IsndBHeHgJYpl4LQAQVPWa+W8SwAb0tMogexJldRR3vvpWy0dTU9O56QAAiSEdMtYcX+T56/8n9NC/Kyh6epdCSJ3nyca2yOnsIAMyHjPVi6kuCqFJpDFdylM5V3Ra1djDHCqzy69Oc4bfsc5gILCgJVNF8rnEh4qQj7WIG1YZjYU21EukONxl/K8CSAOXDx+yta0DdXyqTgM8flpXAQ4XVbmQ879ndZAjWfIrrBCy29P8vrm/zyn6DXOhn+oqCJju4UFT75mVvO4/OJaVoyjINf5xNAiK1Nq7HaBakQ62Wj9ttyYr/lyRcjjop9KXk6khOFxSJ4Qz/cBFjL8obwhD7xMmNHy9yYrLMmyHzSTeUiG8Fmw08msr0qmVWOhBqn35j9NqyF5Ud50vl9KjPX/kVqzJ1NRMeobKZkvtFmFUnbB5Y+7bPO0rMDVuLMKx/e1wWxAU9uH2
 gOn3F5kq
 RVY0QURS4SSr6O89V6is7EmmYRIdCT5mUfJOozI3kkFn3d6ViC6JXOdfCzofvcWnih+5SCNlXYZITL2BReEagLBYTfSucrc7hbJTVGlhzVB0fMfnmn2q8nc/TyndN7m0UjNo1Lu5w/nUApCjXG3M7wt/bXpJiXqyl12ZKZG3VgB7FOftzfjrP8nld7ZmRWz/yJXNR/NwhZDWkIROuYhoLtQMlPdGagcJNj2YcKryoa8EnU9CSZgxbrLmo6a6dsqUWCOBfoBwgGr4BTimhd5oLnwcLlQ4N7TUpC/1csv4zfJyRTh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 05:51:52PM +0800, Barry Song wrote:
> On Tue, Jul 28, 2026 at 11:59 PM Youngjun Park <her0gyugyu@gmail.com> wrote:
> >
> > From: Youngjun Park <her0gyugyu@gmail.com>
> >
> > From: Youngjun Park <youngjun.park@lge.com>
> >
> > setup_swap_clusters_info() allocates cluster_info for every swap area,
> > not only for SSDs.
> >
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  include/linux/swap.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 2cb1d29307c5..e12c73891b48 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -246,7 +246,7 @@ struct swap_info_struct {
> >         struct plist_node list;         /* entry in swap_active_head */
> >         signed char     type;           /* strange name for an index */
> >         unsigned int    max;            /* size of this swap device */
> > -       struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
> > +       struct swap_cluster_info *cluster_info; /* one per cluster, on every device */
> 
> Do we still need "on every device", since it is on every device?
> 
> Thanks
> Barry

Hi Barry!

Right, Will trim it to /* one per cluster *

Youngjun

