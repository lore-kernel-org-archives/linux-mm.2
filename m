Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C502ACCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3688E0026; Fri, 10 Oct 2025 14:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B87D8E000A; Fri, 10 Oct 2025 14:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36C68E0026; Fri, 10 Oct 2025 14:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2A638E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:43:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E4DD13AE11
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:43:12 +0000 (UTC)
X-FDA: 83983077024.29.D1B7FC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 725C920013
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:43:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDBYYi+G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of pauld@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pauld@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760121790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMBX/pZ53RIz57w9TIlg7cS/xGYbde0rk28s7vX7D6Y=;
	b=Po+7COCq/wEhdyZJlYMjQ9qMH6aYKatjdf0ZT2JH+lWW/waRVEJF9uT4YaEIG1xHzxmLgE
	1jmIUYyFMs+GH4vzdWWmsjVLDM/jBYI73kL7ARzmGyeuuhMnLP/Cp5k5wSxSSNtUPbyeM7
	NmgcnvSpdf48EG18jI+DQd3T5hWxujI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760121790; a=rsa-sha256;
	cv=none;
	b=HsyO0wrL79JwmlLJs/zCyFPzTgaNvFnaiRekcG5w8t2stuAx38N2tkZxklOXv/0ZAkQYvH
	BUeQtYIR1oNAwavf/1+oUMLqwB8AncM/ZMWblrnrpGc+l+q30zluqEQly7gYZanSMGS4XS
	wdNoD3vPjVesfIfHgDjEvuw8r2BrUA4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDBYYi+G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of pauld@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pauld@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760121789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nMBX/pZ53RIz57w9TIlg7cS/xGYbde0rk28s7vX7D6Y=;
	b=jDBYYi+GHkjQBnjDkOW3d8NSV6HYHfeyjnNLe/2ax3Ae22OU1kSDgQjoDPHGY0C/qgUBk5
	GOXQfmokXjkno247ewbpOBJCTR+uHxA3ao8AXKDj/HSZoyYk4rjeVfaPS6ooNs7HotqgHv
	S9XQUk+79cOKnHd3WNrtCBJuamCjVdg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-Pr-TSykvOgaC7KVbhcuOmw-1; Fri,
 10 Oct 2025 14:43:05 -0400
X-MC-Unique: Pr-TSykvOgaC7KVbhcuOmw-1
X-Mimecast-MFC-AGG-ID: Pr-TSykvOgaC7KVbhcuOmw_1760121784
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 316DF18004D4;
	Fri, 10 Oct 2025 18:43:04 +0000 (UTC)
Received: from pauld.westford.csb (unknown [10.22.90.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A02B01800578;
	Fri, 10 Oct 2025 18:43:02 +0000 (UTC)
Date: Fri, 10 Oct 2025 14:42:59 -0400
From: Phil Auld <pauld@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: Boot fails with 59faa4da7cd4 and 3accabda4da1
Message-ID: <20251010184259.GB436967@pauld.westford.csb>
References: <20251010151116.GA436967@pauld.westford.csb>
 <CAHk-=wg1xK+Br=FJ5QipVhzCvq7uQVPt5Prze6HDhQQ=QD_BcQ@mail.gmail.com>
 <e4f2a3e3-649a-423b-9696-6406ef56340f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4f2a3e3-649a-423b-9696-6406ef56340f@suse.cz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 725C920013
X-Rspamd-Server: rspam02
X-Stat-Signature: h4j3tty36gpi5oikff1btskyzmddgjpk
X-HE-Tag: 1760121790-785745
X-HE-Meta: U2FsdGVkX19WgabFwZXSvyi8hV8aSMLYom9jwF/sbB2X53URbQMGjnmurx3X/EEk1tQYVgxDwRGsk/emj2rd1ZgxEcIM2lO9oj5FNcemlW2PRBoBXQSM5EjEm0z1FK+h/XNPWVFgT0VBgK4Ne64fv3K7ZCZ2a1eatbhWJp91gxN1QSC8t0yWy1j9zgjpMBiNBn+EDpnWhyVcd7pcSXtvU/tFNeVf58F5VsqTZUEbqOkVj9qnBlwmnBp7TQS/DKhs3IUheN/xUKk5GzpQsdjgrM7YAle644MQ3ZSBctB2hlu3D6yzIgxx05GhhWPYYO3ehL14EdaysiPSHXe/vwjxp7e07n/Cg9VdGCRA9v+TH8IIYe/qK+1LbVwDMdnxUTmnm7aicwa1q8MtV74ZDkFLwRHbgq9dC7HIJPO5lkbRkrgaTz7JmohRtDimHdhUGFTiPaIit84RnjRrKXUU+10jsUdDwn8FKlz3sYX6u8ZZPxhQ3/w/hJo81cIoLSGqW3yYtoDMCxqjwXvqtYLDYiKJsOm3TFeJ8svqO6T5EK6x/rmYB2ha2Ho0CIQGZdkrZeJ2XnzzQajY6AQu26JM8AaEVWo+ZzKZW8BSbmpcwIIUBzUcwcTWFcgzbb48VdM71Oj+vOhL3ZykF0Q0xpEYJuhBaHMFOQxwuQpp383+uXFg2stCUHnUNrnk3HTGIPugbFhgyKfOlqfssYHIJTWO3uowQqtxaVHY3b+QbBlmjrHCwDPs8DYoEqWK1WSExA88pRonFpsVl71VNNlkCmCv/aITxRTTKc+RJLn2I1/5hohYVdhUNbUonMNBU5XHaoyuf/jml4dR1fgeyeB+8FmP7tgmTXGgAJOVfYKukAbJqTlNvJYe542R9FQiMHYmgHrxX4xrhL4GD+T45hx6tUsAG2Cu2/+cpjgfpGFyqabXrGvIkGXFQIdRYmgvUcTZGd0LmMx9Mwsl8d+7vH7ix/LPxd7
 N+Y6RGsq
 E+p5epvaHSFbTBpJqu9N9y4KK09DuZWBN3qWLvFW9wKLSsQHhvTsqJM/pR7ynv/KkiNgazIatG6Vo8jFxB7/cqxTkZ4esjv3bm2H74CZhYUEyqIbUg0LjwsEf4oiYiklCE7cHNY5mnVBZcQoPsFUTraejcgFgI+ViJxWOLF+D1pSHSkKP3my96w4Nxz7QngrrcUq1RIJqLeslMpxgnIwIKovZKGIezyU/Ouzozo75hFGkMcrk9xG5YLcIVNdf0Us4mkEsB+kp+7hDh8TuvnFhlHx/0WkWM4U/PZuKQdt1rwRX8CQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 08:27:30PM +0200 Vlastimil Babka wrote:
> On 10/10/25 20:19, Linus Torvalds wrote:
> > On Fri, 10 Oct 2025 at 08:11, Phil Auld <pauld@redhat.com> wrote:
> >>
> >> After several days of failed boots I've gotten it down to these two
> >> commits.
> >>
> >> 59faa4da7cd4 maple_tree: use percpu sheaves for maple_node_cache
> >> 3accabda4da1 mm, vma: use percpu sheaves for vm_area_struct cache
> >>
> >> The first is such an early failure it's silent. With just 3acca I
> >> get :
> >>
> >> [    9.341152] BUG: kernel NULL pointer dereference, address: 0000000000000040
> >> [    9.348115] #PF: supervisor read access in kernel mode
> >> [    9.353264] #PF: error_code(0x0000) - not-present page
> >> [    9.358413] PGD 0 P4D 0
> >> [    9.360959] Oops: Oops: 0000 [#1] SMP NOPTI
> >> [    9.365154] CPU: 21 UID: 0 PID: 818 Comm: kworker/u398:0 Not tainted 6.17.0-rc3.slab+ #5 PREEMPT(voluntary)
> >> [    9.374982] Hardware name: Dell Inc. PowerEdge R7425/02MJ3T, BIOS 1.26.0 07/30/2025
> >> [    9.382641] RIP: 0010:__pcs_replace_empty_main+0x44/0x1d0
> >> [    9.388048] Code: ec 08 48 8b 46 10 48 8b 76 08 48 85 c0 74 0b 8b 48 18 85 c9 0f 85 e5 00 00 00 65 48 63 05 e4 ee 50 02 49 8b 84 c6 e0 00 00 00 <4c> 8b 68 40 4c 89 ef e8 b0 81 ff ff 48 89 c5 48 85 c0 74 1d 48 89
> > 
> > That decodes to
> > 
> >    0:           mov    0x10(%rsi),%rax
> >    4:           mov    0x8(%rsi),%rsi
> >    8:           test   %rax,%rax
> >    b:           je     0x18
> >    d:           mov    0x18(%rax),%ecx
> >   10:           test   %ecx,%ecx
> >   12:           jne    0xfd
> >   18:           movslq %gs:0x250eee4(%rip),%rax
> >   20:           mov    0xe0(%r14,%rax,8),%rax
> >   28:*          mov    0x40(%rax),%r13          <-- trapping instruction
> >   2c:           mov    %r13,%rdi
> >   2f:           call   0xffffffffffff81e4
> >   34:           mov    %rax,%rbp
> >   37:           test   %rax,%rax
> >   3a:           je     0x59
> > 
> > which is the code around that barn_replace_empty_sheaf() call.
> > 
> > In particular, the trapping instruction is from get_barn(), it's the "->barn" in
> > 
> >         return get_node(s, numa_mem_id())->barn;
> > 
> > so it looks like 'get_node()' is returning NULL here:
> > 
> >         return s->node[node];
> > 
> > That 0x250eee4(%rip) is from "get_node()" becoming
> > 
> >   18:           movslq  %gs:numa_node(%rip), %rax  # node
> >   20:           mov    0xe0(%r14,%rax,8),%rax # ->node[node]
> > 
> > instruction, and then that ->barn dereference is the trapping
> > instruction that tries to read node->barn:
> > 
> >   28:*          mov    0x40(%rax),%r13   # node->barn
> > 
> > but I did *not* look into why s->node[node] would be NULL.
> > 
> > Over to you Vlastimil,
> 
> Thanks, yeah will look ASAP. I suspect the "nodes with zero memory" is
> something that might not be handled well in general on x86. I know powerpc
> used to do these kind of setups first and they have some special handling,
> so numa_mem_id() would give you the closest node with memory in there and I
> suspect it's not happening here. CPU 21 is node 6 so it's one of those
> without memory. I'll see if I can simulate this with QEMU and what's the
> most sensible fix
>

Thanks for taking a look.  I thought the NPS4 thing might be playing a role.

I'm happy to take any test/fix code you have for a spin on this system. 

Cheers,
Phil


> >             Linus
> 

-- 


