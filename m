Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF55FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 04:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A49E6B0092; Tue, 15 Sep 2026 00:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D196B0096; Tue, 15 Sep 2026 00:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8F66B0098; Tue, 15 Sep 2026 00:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EAAB6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:38:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E083E1202D4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:38:28 +0000 (UTC)
X-FDA: 85214740296.12.7490B1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2A47B40002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:38:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rJvSqFS1;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789447107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdgefM+gLOSrfxKV2nJVI9LHcUcy+EC4TLzdGDZ6DdE=;
	b=rUYXeYuKQZzgYOnlSH2SxBGR/ansg/LBRspJee0TbX3Gy4DtBUsJi69UAMpvLTex/smJYL
	Zplsz6IE9oqQOQSsR70Z9VXgzSLGmVAXpkCVxRWsxkovxh06aJWC+h3dR3Z0jMfaqJuA2x
	fRG4xL3+uq9MVZ5OYTF6Q3wqburPybg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789447107;
	b=T00qz2PpIfY/PoTRNbMk7p/Qag0KZFNMIQhmX8GBLPShoWvAYuRn2TB7rWcnQ5TxsKf9K4
	epFM5nSQVSO6vP4jHSQjyFioCg2V/xwyIel+FHNOixaTtboRq3AAVjGkJ9VZKvkWdhn5KD
	MUBpul1ni1Vz3r1D52VHG5M0NHAlTvs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rJvSqFS1;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFA7643FE7;
	Tue, 15 Sep 2026 04:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5C31F000FF;
	Tue, 15 Sep 2026 04:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789447104;
	bh=SdgefM+gLOSrfxKV2nJVI9LHcUcy+EC4TLzdGDZ6DdE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rJvSqFS1NGmQwvpKLCulwQuz9qgUAy4uWK0qXrftCjhnXLS1y4TKyDpXD7yS4D0aV
	 yB3fhhNeh3V3s8ycHrJPcAmCGoUDfel90Fb1+LWKleZpP2Lmme4Cv8iKuN3lKzSTlM
	 f2YVE+xIws/3Y+zTqLRvJTi+5b+mefJfqGVwWaN0=
Date: Mon, 14 Sep 2026 21:38:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Ye Liu <ye.liu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH 3/3] mm/vmalloc: extract show_busy_info from
 vmalloc_info_show
Message-Id: <20260914213824.2b5d9af8a5be89fe09e1629b@linux-foundation.org>
In-Reply-To: <aqgqjRJ8qpYmx04v@milan>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
	<20260914-vmalloc_study-v1-3-526f68559706@linux.dev>
	<aqgqjRJ8qpYmx04v@milan>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A47B40002
X-Stat-Signature: j7nd1tjz53ogkd8wf1kj667fjz6we839
X-Rspam-User: 
X-HE-Tag: 1789447106-639706
X-HE-Meta: U2FsdGVkX1/hrgqH4PYfiLMNC1MjcglhNAFhoxF8uVqj1QE/QM/yk9RU73imHo7FLzaz/Hw785In4maG6/9o2HAYPNFxafKzii9CayrTT8++S2bhdKWlLMCwnHoDGvc5HCmrKBpl5VGH/OOYalu2aeutueE7xdiXoL9oeEXt05yXvWzwxPEfhav78JZqvOZL2BPl8+R2NASZoYSoNPdzqLh5qQjTTLxZX3ipZjxKUW62UJN73BjFYDgJUx9p4zMyFXNb8609c0KNExexaNLSDC77xPvdOwGt5BN/oDEK3fb9DvLGkOmyM07q8paSd9hn/TuzJoY117yYUUX3cUoTNc6+an8hPa1bqzRyaa3wHTThWS6S/1oTatK/wQV5AU05aCjIP01qeUpQ3s2Xst1DJcn+wkpF+ZzP3XynkI+Qt9YYkya/dgQCzwAN/0Y32pYdKDp5f67JAz3yYTEZJBBTWDNKNHiW7JFLqBiLdH9gJ96UFQWMNgkIFdFxe8Q/5BXmj1oQPOkzWmfW7yUzhCwflS96/6uvVFOZY8mmfpsgWbtF+ePiyKxA5yybkyv6NNr5I2ZTqPGAhW9ZPIyjwFqeUAYxUAHTocbwW6VZ4Z7g7zZ6qnzAphrR9KwCEvWij8bYxJQ1vhL/b5EWTyNqJo5h1dNThMRbBVitzXrXZuc8stuMeM9QS7cm9QVfE+orw0/ph4P55aRdRawg2P1edPOOLah8plVskF4ZBZ0Gju2DZWTULjA2bqMwc/RPmf6t3+O8sOz2rh+gFTPTMiXAMYrLcOJ2CkUR4rYz9GewbSPpi7nr7boFa7vbRE+JHW65hbUyXT5y+86w8/H8inQQcMlD1a5Swb3XuX55OKxMpkECmdnIz+RbCyo/jr2V3mXo4yK5bz4qHaIUuFQnmRe7BVEi06qF7qk0VBiyZm+x+/C/imlVYyzd+A/GuSMhAufRjxXya85lB3VTSM05bpANayy
 xsAqcEYf
 Nw28CvvvVA8i9vC33d5Mubh3bV2qgTNQuaBqOvDrCb4VeRueVGiPebDZkUKlhzrexMxkXOsdDd/Vu0W4Kss6sJU1Kx1lJ0VTkI2FYqDxxMESlIeoO+kUievK/mnLh5vxLB35X0/OxCnCFF+m676C+YMSUu1qvOM2eC5VVui5IE7WizE8Bagz5I+oIFFqhlaRREUInyyFczfeUkse/JApMRN1M7fkQUNAuoPE0swr2aMLtcCgjpp0knTK7WUYG5kK1qWbNlZrZTvclv1ZiXaKn7fK4VlW5Ixfv+D6JFz6Fv1BvXziKwu8IGNbtIEbl/Acxi4p4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 19:10:37 +0200 Uladzislau Rezki <urezki@gmail.com> wrote:

> On Mon, Sep 14, 2026 at 11:34:02AM +0800, Ye Liu wrote:
> > From: Ye Liu <liuye@kylinos.cn>
> > 
> > Extract the busy vmap area iteration into show_busy_info, mirroring
> > the existing show_purge_info pattern.
> > 
> > Signed-off-by: Ye Liu <liuye@kylinos.cn>
> > ---
> >  mm/vmalloc.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 797933ba9451..7638845377f5 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_file *m)
> >  	}
> >  }
> >  
> > -static int vmalloc_info_show(struct seq_file *m, void *p)
> > +static void show_busy_info(struct seq_file *m)
> >  {
> >  	struct vmap_node *vn;
> >  	struct vmap_area *va;
> >  	struct vm_struct *v;
> > -	unsigned int *counters;
> > +	unsigned int *counters = NULL;
> >
> Is setting counters setting to NULL odd here?

static void show_busy_info(struct seq_file *m)
{
	...
	unsigned int *counters = NULL;

	if (IS_ENABLED(CONFIG_NUMA))
		counters = ...

	...

	if (IS_ENABLED(CONFIG_NUMA))
		kfree(counters);
	...
}

Presumably some dumb compiler or checker warned about
kfree(uninitialized-val).

