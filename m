Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED947CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 02:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CD4800FE; Mon, 27 Oct 2025 22:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DFD800E4; Mon, 27 Oct 2025 22:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0338B800FE; Mon, 27 Oct 2025 22:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E57FC800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:24:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93C78140174
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:24:32 +0000 (UTC)
X-FDA: 84045929184.23.50796B7
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf08.hostedemail.com (Postfix) with ESMTP id E39E916000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:24:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761618270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OhsIvwmXk/rH8Q485xyp4S6yGHBHiwPnvtST9OqBdZg=;
	b=qjAqF1pCr3hANIPTaCUkEj0k3bpW+i1g6fZHavvYhI0FJvPOHT3Ruiu0wo7LmCs1agnRrq
	YDDk/Ah5ovQe8afGvaXY4mll9MxVM2sXJerNr1VR+aioqeVx64fxjhxpQq3FUYK4/ubyxj
	N3rcDcLjX9Nw3ZLuApq1FNKioCKwQt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761618270; a=rsa-sha256;
	cv=none;
	b=kcge1aKM3hxmsNNwut4yxUXHVrS3lNfzVSjwlGSgtXW6tLKXMLgcGQvpogMiz63CSdmVZX
	HTTYYR8bx8VBihZHQ8+3ivi4lBCkFyNygGSN+j0yzbk3XtK3E9eWOWiI35f4oDUeicpO28
	9icJ/NC4ixQOK10ZOyJuSZ5NnGRc2rw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c45ff70000001609-8a-6900295ba92a
Date: Tue, 28 Oct 2025 11:24:21 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mina Almasry <almasrymina@google.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	toke@redhat.com, asml.silence@gmail.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [RFC mm v4 1/2] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251028022421.GA77904@system.software.com>
References: <20251023074410.78650-1-byungchul@sk.com>
 <20251023074410.78650-2-byungchul@sk.com>
 <CAHS8izPM-s2sL_KyGyUyv37PfZxNLf029DrXpQe8fo637Rn+rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izPM-s2sL_KyGyUyv37PfZxNLf029DrXpQe8fo637Rn+rw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+++cnXNcro7L6p8SwaKiIGtR9AZSZhCnIjL60EWiDnlqo23F
	ZqZR4C0qSbOs0LlkYuUyc23a1JWSm5fZ1RbKotLSUrppaYmXmelE8tvD+z7v83s+vAwhaxeH
	MCptrKDT8mo5JSElPwLzl0cvnaZaWfBqHhgtxRTcHYiHwg8VYhgs7hKBsciO4PfgWxpGq+oR
	9NU2UPDN1YugIL+fAOPLVBL+WIYIqHR0IfiafY+Cz/XtNNy1bYe2250kPDpXTkD7JTcF6anD
	BFQNdtOQXGEeCy5NpKHJniGGq0O3CChP/EDDa4eRgtbiUTF0OtNJaDTcIeHntVoC2jIioN40
	B/qffkdQaykXQf/FGxQ05zhE8KCqmYYsj4mCjtQ2BB5XOwnXfOcpyE3KQDA8MBbZnflbDLl1
	rXREGJfk9VKc63sPwZXdeSPiWrIvk5y3+omIqzS8pzmT7QRXal7GpXk9BGcrukBxtt4rNPeu
	5RHFubOHSa7y4zqusqJPxKWndFNRs/dJwmMEtSpO0K1Yf1CitLyzo+Png+N/3DCgRFQ3Mw0F
	MJhdjR1WHzGp3dbr5Lgm2UW4M6MUjWuKXYK93kG/J5hdim9WXxanIQlDsF00fv4ik0pDDDOL
	1eC6Zs24R8oCNl5t9XtkrBnhkbwGamIRhBtzPvkBxFioL89DjN8SbCgu/MtMjBfglAe5flYA
	uxO/TnL5O8xmF+LH9gbRRM9zAbjEETSh5+Eas5fMREGGKQTDFILhP8EwhWBCZBGSqbRxGl6l
	Xh2mTNCq4sMOHdPY0Njn3T7ji65AvU27nIhlkDxQ2qQeVcrEfJw+QeNEmCHkwdLwXJ9SJo3h
	E04JumMHdCfUgt6JQhlSPle6qv9kjIw9wscKRwXhuKCb3IqYgJBERMYud/7MyXGHWD1DHS0R
	Q1kzNocXKnp+7Z8+f2T+jk1b2Ld8x6k1bUHuhj3BVmUBuzBfERu1NXJddDl/8/7W5PUlewce
	6tc6Ukyr7L4vi7eVhe62JruOHj4duaGzVTtalnX2Qg2fat7xJ8wSckD57JZa8WzaGeNGRp/5
	q9HYV6VolJN6Ja9YRuj0/D+lH0RNdQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+++c8z/H0fK0rA76IVhEuC4WFb1d0S91CMqKIKigTnVow81k
	S9GwmLqoRq7ZDZuXVlmZGdKs6Swlnc7ZPWWxyDYzU7pZmUlOa21G5LeH533e3/N+eBlC3kLF
	MurUA6IuVdAosJSUbliRN297/AT1ggGHBIqrKjHc+JkJ17pqKRiu7AtbFQ4Eg8OvaAjVuxF8
	b27F8NE1gODyxSECip8aSfhRFSTAWdeH4EPhTQzv3N003LCvh8DVXhLuHa0hoPukB0O+cYSA
	+uF+GnJry8PgagMNrpI2Cp45zBScCV4hoMbQRUNHXTEGf2WIgt6mfBLarNdJ+Hq2mYCAORHc
	tmkw9PATguaqGgkMnSjB4D1fJ4E79V4aTrfbMLw1BhC0u7pJODt6DENRjhnByM8wst8ySEFR
	i59OTOBzfD7Muz59Ifjb119K+BeFBSTva3gg4Z3W1zRvs6fz1eVK3uRrJ3h7xXHM2wdO0Xzn
	i3uY9xSOkLzzzTLeWftdwufn9eON07ZJV+4VNeoMUZewepdUVdXpQGnHYjI/l1iRAbVEm1AU
	w7GLOc+tc2REk+wsrtdcjSIas7M5n2+YiOgYNp4rayigTEjKEGwfzT1+YsEmxDBTWC3X4tVG
	MjIWuOIz/rGMnC1H3K/SVvx3MJlrO98zVkCEoaOl7URkl2DjuGu/mb/2DC7vTtFYVxS7ievI
	cY3dMJWdyd13tEosaJJ1HMk6jmT9T7KOI9kQWYFi1KkZWkGtWTJfn6LKSlVnzt+zX2tH4ee6
	emi0oBYNdqxtQiyDFBNlzzQhlZwSMvRZ2ibEMYQiRrayaFQll+0Vsg6Kuv07dekaUd+E4hhS
	MV22bqu4S87uEw6IKaKYJur+TSVMVKwBOc0hpqz6V8OjKcKRi53PS/2G5PhvwcOy2M2Lg7aG
	NL0n6fCq5G1bok0LdliowHvmypD4OXB3+Qk4sh5nKo/eNv4Q5EH1WnmuZ47uUrnFbVqj9Bq7
	Ei58WZo0Kd3uV+6emzzQ6N2cnZQdHbf76YZNj3oWVcS7axpznbkzp4ZOJypIvUpYqCR0euEP
	GRjoFVgDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Stat-Signature: e9afkd4dbmcn9esppky8seq67syk3x1w
X-Rspam-User: 
X-Rspamd-Queue-Id: E39E916000B
X-HE-Tag: 1761618269-249810
X-HE-Meta: U2FsdGVkX1+sP3JJwC7hmPhu6NbNgis8KGlgOYFWdD287cfuBcn7noy4JKwUh0WfGpto5jat/huUhNuGzt452PRo8vJ5kYvgNSgdQP64NoEEZZVKZm5M69ZqLia/ZSJjQiSTx5LaYEADASljkdhPcBox5JS6xfr2e1h0kh5XwKcj7isBUZI2Fe9m7FoMzk74F539iHC+2kx46vCax3xLak7S7yIsi+eV7AThrpAArO9hN4OliQROC2g6nrZ5lMRW7Qaby2ncEiETScnys0l2i4gV24kHCdWhuAbhKton99bjhWykuP1On2PjFpryAMPglki7D40v25goR43AkB99f4T2s7ASnDVxjaPequ+g1c758O8zQltxrBoHXZtqFMXAktN96AHD4647Hcw7dCyqwilCEsCmHtU4qXvakocE0DORiGeRvC9QZ7r0bToG76NJrM7Fmo//B0E76LNflWwHvEGJlcWoF2FN8QMeW4peB0p+kAUD1StcGCiV4zpHE/r6JgMiWiQn/HwIqbEWkpfa9AR3Emq1ehPRBB/O/ou6CF3mnzmmneyNnHyGb8hIkmybFKCdsIOqZD7PnwhkHMlXIPk493rJbTeS7bdxrznxORGMQCN+3BMCqJk5MdXRafVvIqjOHRA5/JHSTSUX3f6OUxVqmBkf+uCm3Gzx7+gQPxKm63gncVa4gXHTX2ffrBpvo/xwATMO3L78UBfp1tpCEQ14oSsTeWuXMl0ic3b74Dsv6OKaCfUq4lTgOmz+A4Nd2zBAUT8h01B3EGGmQoO1tCuMqp0nNrQLnCNiJEN+a+1kBHcsqmYbm7ODZFigXsayuc4xqvpkZH0nozAT4e1lAobRwLRfqlF3X19R4S15Kr+L9pgvubt9V2AZTQH65F0+RBxEndwDB11+Xjl0OODdv8HS0ER3l4UOPwkr1Sxf+Mli3DJxtm4JKA30zGUPJvjUxZt0YQcEo6sZXJRDyCG
 dM/Kun0I
 Vl5YP2Dzb53yLwiEyhxKOVzBbHov23ogCIdxUGEZEcBbn1CQpCs4AxPOg5D9vkrnC10+0zCbzT1hNUfWk6Xm89ph/0U9peusI3s773YMY4lARZl7VKvDA1hfygbIsiivasnPecH3/PowrhaG8rIzLJORxJEXeQ+IDb5IdRQ5xmHDHQ+S5v/xtBGWItu2TEJV43yyqYExACg5cxbZcKEs7OCw3Xxi0gsOTVEuY2XSdVzdcU+IBUK4yb4UKWzBL0PCWfBYICjiWTnpUF+g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 06:25:38PM -0700, Mina Almasry wrote:
> On Thu, Oct 23, 2025 at 12:44 AM Byungchul Park <byungchul@sk.com> wrote:
> >
> > ->pp_magic field in struct page is current used to identify if a page
> > belongs to a page pool.  However, ->pp_magic will be removed and page
> > type bit in struct page e.g. PGTY_netpp should be used for that purpose.
> >
> > As a preparation, the check for net_iov, that is not page-backed, should
> > avoid using ->pp_magic since net_iov doens't have to do with page type.
> > Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> > page pool, by making sure nmdesc->pp is NULL otherwise.
> >
> > For page-backed netmem, just leave unchanged as is, while for net_iov,
> > make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
> > check.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  net/core/devmem.c      |  1 +
> >  net/core/netmem_priv.h |  8 ++++++++
> >  net/core/page_pool.c   | 16 ++++++++++++++--
> >  3 files changed, 23 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/devmem.c b/net/core/devmem.c
> > index d9de31a6cc7f..f81b700f1fd1 100644
> > --- a/net/core/devmem.c
> > +++ b/net/core/devmem.c
> > @@ -291,6 +291,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
> >                         niov = &owner->area.niovs[i];
> >                         niov->type = NET_IOV_DMABUF;
> >                         niov->owner = &owner->area;
> > +                       niov->desc.pp = NULL;
> 
> Don't you also need to = NULL the niov allocations in io_uring zcrx,
> or is that already done? Maybe mention in commit message.

Yes, that's been already done by kvmalloc_array(__GFP_ZERO).  I want to
leave a comment explaining that on io_uring side like:

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..f771bb3e756d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -444,6 +444,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		area->freelist[i] = i;
 		atomic_set(&area->user_refs[i], 0);
 		niov->type = NET_IOV_IOURING;
+
+		/* niov->pp is already initialized to NULL by
+		 * kvmalloc_array(__GFP_ZERO).
+		 */
 	}
 
 	area->free_count = nr_iovs;

However, I dropped it as Pavel requested:

  https://lore.kernel.org/lkml/8d833a3f-ae18-4ea6-9092-ddaa48290a63@gmail.com/

I will mention it in commit message then.

> Other than that, looks correct,
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>

Thanks.

	Byungchul

