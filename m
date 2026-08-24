Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDBEBC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF116B008C; Mon, 24 Aug 2026 13:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96416B0092; Mon, 24 Aug 2026 13:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF8A6B0096; Mon, 24 Aug 2026 13:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92A506B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:33:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C1ED120211
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:33:08 +0000 (UTC)
X-FDA: 85136858856.04.8DDD3C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 773C82000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:33:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+i5MaxE;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787592786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcIvVs7PFyhard8s6CMxssi4jiT5qkPDU3qCnhbC5zk=;
	b=Hp922bG49Sukjn891WjMPaFsSPjSMDN50RFfCUJsslevoIptVUWLtC5CpIj4GKjaykByZD
	T2GTIi4Ari+s56AuzOPSaD2YCYFurBs3ZAdwvh+vATRdxpP5T5CJvlS5PiSPj1YsuDneqE
	IGrJHzlA3x/0y+MUteopqi8AVoFA8KU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787592786;
	b=uMl0AbKrKjVwaffSxxofBuedADlnlAnyd8jyxoST7exxh1pcL3Gm+r0HoNd59cAJys/fGx
	2ki3DRO2Vl40fF2QJS4rLSBLntYDgtZ8xONW32xSGgtxL1kIsFgaxPfn/NBLPNb5DRy7/j
	DGdYAbS2H/PU/s6Oso0ps2rJRRS7oA0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+i5MaxE;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EDFD6011F;
	Mon, 24 Aug 2026 17:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E2A1F000E9;
	Mon, 24 Aug 2026 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787592785;
	bh=vcIvVs7PFyhard8s6CMxssi4jiT5qkPDU3qCnhbC5zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d+i5MaxEtcU+1yCT63EDnh+FmVOdipnlTw5o+j5+bIk0RkWQJZ5MsnAnJ+e01sAXG
	 zkHmxUCnj4mUOhx+PPCqnMIme8zX0W2GkiEcrHGZpJz0D/u6cu/U4Y9tnmQJTHJi3t
	 +K7W+TWEXIfAMePCWIdapL8BF2BoBjsf8SDh1KO5oREt7kNHq2+F5IFWecnfzskri7
	 iwrnmyF2J/WwBN7ESlzJ8GKgcP4/RVbWDUVQMC4sEbHgRfuRzd80rJPKmeVcaGMCx1
	 vTkuAVFd93/g767RqV5KKJYWcLFWCcuqvyplXssHHb7tEDuWuCZMRM7Cm6Me1jpoOH
	 BCjbYn/UG+WYw==
Date: Mon, 24 Aug 2026 18:32:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <aox7tVIQBMuz-xFO@gremlin>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
 <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin>
 <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 13b4uxdmqfp8qxdo33jde3za8sub4g4z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 773C82000B
X-HE-Tag: 1787592786-776358
X-HE-Meta: U2FsdGVkX1+D81TQVMjPkF7lj5JVHf9CVCbrYlDVk5oCe+DeHXSH8kcnWsGvKeL09hEdIy/wUUXL23OHPrt/D0nDFn8trUE7DoXdUpLrSTKwTm62z169rs0aBK6tyWSqewGiCovtbBW4s2jL8b/GWdZbFNe6wstFrnlDr/iI6iid46LkTsQsqsM0dL2NalZmyyYg+NNPQLwtutkFYD/uXJdxqepx7wA/kxunn0xSkQQH6JJsrSf5bx9QLTY4abHawgYUSh6vttZ01rdE9vXUwEgko3rg/TGTBh/uKJFvHjdLhXi7AInp8CGySW4IEIpHDc/kQfmjgxwf7km8AiM/2IyJxPDyv+xDpX+78BHP706A3k/MzR6wPhY3KC1EjTIAq+x+WWT1TlYVH7HwWES/oXm3tSAIBhwhzHQL0Wc/ioz5cv740HsF2fdzQ6ypNccMxtFdocBOBrsjjlN+3dxLm0lWNJz+KfmtemnUZXEnweo/c6gF6IGE2p6VXT466RZD23fVbOOInk0lzFZ/Eni//EFPp0dZAM/Ba3YdTnhO80/NPrpMxvGRxukhuQIVuEd2UP2bZBKh1BpxqBsIaxGXe8Kotz1Qya2RljhqmmXg/8/w7FRmKnfTaM8v9gcpFJmkWs0DKg9xTCefi4CL3e127CdVoT/2OcAXmQAgIEiZ2LenR71KGumb1CJgwj1hYK+Gjl+JCnw+ltHIhQI5FN2NjiRBCL/g0SFDv4C68rV4wVJH3OFsv0dvbAvBTt0IqY1jCYo7S2Xx0p8si7kVo0q4tWW2OsBE7rCpyVPVzdQCtUtAPqg1si9dAwZieg4z2aqckbGrgpHnjFjDC0pApD/8+TQ3qWzMHoWip4OyqGZ6iDx5ZKOvExWEwYGFDZOwZNwpsLacSiwAKxJFOk7bw1CDnN/AbO6qIddIzkZwQpuCboRTXyRrNcLs/ajOyml2eOn8YWkW+0+yMdMQKVl31V5
 ytuOJrBx
 OcHkkAPGhlvRsNlVRdZkNQz9WH4vYCBhGkad84jFJ1vdWxGsMZQwr6MwU2VI/iP8mPwPOxoMS6VX9kMmggM6NRwBqIGR9AXypvG/hMkXFzs5h0WWuGFmPugxUS3jYy+JvBtE7qgZt+qiDbXjpAJfhwWQn+gA+oF4PaJeC57rdGjSzD8iHRzGWSQI2A3Hgu0bWUlnQdtRhunudEx8qHB8rs8+Kg4tFYSp2UKGGuLhzNSH4xHT027et9gpo7u7rP7SKAl9IsOK9YiYUHdUYiGHLAm20odumxm0E3MOnvBzc+xtYcFzvZq24YAPut2OLjh4+y0DY2z8p2lBQqpQj5G50QGiOmNkFa2rVSiELQkjNuILVaWEKlHRks/K6j4WyE2t+T5Io/LPuWEa4gbOEpE05EUhEsABW9uFUVaGEJWx19k3LISw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 07:06:04PM +0200, Jann Horn wrote:
> On Fri, Aug 21, 2026 at 8:52 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > OK so the whole thing is:
> >
> > mem_open()
> >   -> __mem_open()
> >     -> proc_mem_open()
> >       -> mm_access()
> >         -> may_access_mm()
> >
> > And:
> >
> > static bool may_access_mm(struct mm_struct *mm, struct task_struct *task, unsigned int mode)
> > {
> >         if (mm == current->mm)
> >                 return true;
> >         ...
> > }
> >
> > And what this flag is carrying is 'hey the reason we allowed the _open_ is
> > because it's looking at its own address space'.
>
> Yes.

OK cool. Obviously do agree with David that calling out the ownership aspect in
the name would be helpful!

>
> > I did wonder if what you're protecting against is even a process updating
> > execmem _it_ owns, no fd shared anywhere, as something LSM might want to
> > prevent even so?
>
> Sorry, can you rephrase that? My goal with this series is to let LSMs
> block a process that tries to modify its own non-writable executable
> memory using /proc/self/mem; I'm not sure if that answers your
> question.

Right, I guess my confusion comes from David's clarification about passing an
fd, perhaps I misunderstood that being somehow the _primary_ thing you were
protecting against.

>
> For context: In this series, I'm using "execmem" to refer to the
> SELinux permission PROCESS__EXECMEM, which essentially controls
> whether a process is allowed to create writable+executable mappings
> that can contain anonymous pages. Additionally, it blocks creating
> executable mappings of S_PRIVATE inodes. There are other SELinux
> permissions for things like making a VMA containing anonymous pages
> executable (FILE__EXECMOD and others) or mapping files as executable
> (FILE__EXECUTE). FILE__EXECUTE is granular, it can be granted based on
> the security labels of the process and the file that is mapped.

Ack thanks for the clarification.

>
> > The sharing a /proc/mem fd seems like that's a pretty dumb thing to do in
> > general :) but I guess you have to protect against that.
>
> Yeah, it's a kinda weird thing to do...

Yup :)) but I guess we have to account for people doing weird stuff...

In this case (I do mention it in a reply elsewhere I think) it does seem
like perhaps you should separately check for current->mm != mm of (what was
originally /proc/self/mm)?

Or at least it seems like a crazy thing to be able to get full access to
another process's memory (that it... gave you though).

Anyway perhaps overthinking it :)

--
Cheers, Lorenzo

