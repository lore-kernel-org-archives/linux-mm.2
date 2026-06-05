Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD09CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 20:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21BDC6B0005; Fri,  5 Jun 2026 16:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CCF36B0088; Fri,  5 Jun 2026 16:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2CF6B008C; Fri,  5 Jun 2026 16:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 004F86B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:54:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AA4C8CF77
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:54:46 +0000 (UTC)
X-FDA: 84847062972.12.B39AD86
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9BEB0140009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:54:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UZ1qkrzd;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780692884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SslXJgntqwAF+9YvM5v4vsv0Li+nQ5gtHKqQFx2cM1A=;
	b=coLeM2nFinev9Agpk5hGR801ksD/Gjn0u6jSm7dTmEwE59CedlE5fXxWqWEfkLU1I5vDsb
	iVgSvXgyVKAXsGB3GnLsFC+nxMCHQNFCCs8KXdRX2BbZRgGTrGV9uP7oFaoaiEsiHA68K+
	72uAQeB0FypIIbp9D5CU9yl3/2sxYZs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UZ1qkrzd;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780692884;
	b=WdJ0mHXhv4epIAV2CA+NBaoU8FKJ/78JXnsakXgWko8Jwb1bOtLyCbcYqzzp1SFRI7TZh1
	GYSQENJJz+piW7F+gLNkj3+SuPQBxylPq4pkwPh6qN+WHxgxI1J4IS2ubBfmg1kSvY7LW7
	hxMZGYBcVvxIMa+7ZUzWkIAUQC+2Bf4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SslXJgntqwAF+9YvM5v4vsv0Li+nQ5gtHKqQFx2cM1A=; b=UZ1qkrzdC51ngjCGktqDZVzAX2
	yCgvXyiXhpjykmca6pMQJXHGguhKJPRzJ364f1c/mnaeEzzSaowVSzfQ94vYrYzqhXNSxrryIa7zs
	16S0wmjlm0Aav5EmuHod9r5x0B5GizEKl/JaFwQi7Yd9GVDHC/GtRGuRKh4qVD/pHkFohjKOlqKOi
	+4SSsD36n9k4YNzD0qmKnIRjHbIIGur6bX5XGX4B6X2hsRANAvdnWhOgjY/5n0HVxYE5Gz2/OnQTW
	dGv8AEBr8EA83RLg0MtKLN6+OOUF/iGsdtsg+RQZJS6GF0Ayzg8CHHjS87XB58oAAQrXChIH8HZo7
	gSGo2feA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVbYd-00000008a7T-0bWz;
	Fri, 05 Jun 2026 20:54:23 +0000
Date: Fri, 5 Jun 2026 21:54:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Mike Rapoport <rppt@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <aiM3f08bsBM8gD8y@casper.infradead.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
 <aiEX4UTxEnBTjVKo@kernel.org>
 <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
 <20260605093332.7b067876@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605093332.7b067876@pumpkin>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BEB0140009
X-Stat-Signature: a15hwma57oc8xfz58esqofqcux5o8awh
X-Rspam-User: 
X-HE-Tag: 1780692883-920386
X-HE-Meta: U2FsdGVkX1/wompiDTMODX7cP7um7dDck65uT5DlTR24UnJHT/ao5d35Cj5ifZlx3I5DeuZvAo5b8plIoI5k3hjzOXw4qGXUV8lCAIqJsgR+KVaFaugeQvjBtQ3Fk905FLdWuUeaZbWE4QC08S9SOAf5dOFa1qcCxewxKtpk0MTOkdv1A0SKWHUHlW+Or3UuftzrWv1SC395osyM71JSXhwxuBfHijHuctQzSl+5aT2AkaYBC987O2lQ9QLzxbV2T/JHmffhixQ8VoiJ817LTMRi2QM0RXiro9aUXdQSFwt6GH1kjxDLtgJpRnzfs1CSWf8+MIQnVP2KXkmVKXbz6aQaT3FG8fqZD4Zuj/ypciihRdPF6C4QX4HGecxUFRg8+4XHHL3E7g35cqPj3k1lSF8w73GpLvZKuo7dBl+NyNcVAeri9Oim0eaXiKyfBZPbKgHlN5pY71M+N1jnznltroMVCs1TvwyYb4XfUn6guybySCO4G2JDnWszZ7UUq4TJtUy5KRVKLnqWy/zeBhgAmyxcDKqYymiGBvTedf2ZIYbquq92gp8E9shIXVWc43wZx1+n3UYYTw2mYvxhHFAxUjySnWoIY0Frp93/qdRx1FgxkjBg9WLuvRiOFVPI+RQDUxpU6LhqA/DUzBYYjZZJSH4xdhJUer22pZGhSznfZhLMItL7eWd+n9IrxJ/yM5OX7YIp2duIW2aDT+vFWKrHdoOur1EI0zauErTTNE8jpHlDIPRH54NkcGhsMBnT/x89gfUf9MCJF55ZI4WLuaHZkzDrxZC5M55mFnije5CkBjcmSfWqo8VOybPjcWbTQDZo5bbrCWFJ0Spi8+oC6wCtWl/EKxUP3Fk+QT9G8OyNoLxD9siIHzvp27m3Hsmvh4Bc1I+oYSPlm15qrS8GvIOzmJgQXpPTMrYydarRyiybirpeijBPma3Z08wRDLHX7vZqIFKMnZyw4Kqnt+GoyA9
 h/O9B5bg
 4UMWjbDfS8nB8qR16nYKWGLVO5PX5JA3Tbnl2XztAXUd+DuIbXJejBsdJHlYQ8rUI/a7/ZMFDEAvPoRhY8XBaD+NmPUZJQNL7fMAj7G+cee4KPZUGMiCmpUf2B63XxUrJZiN1HFk5cq6Q1rtc/6SzzfEhQ/FTdNAjJXm1D8MI0iNtzC8QOPVQ1UzlaNAKGgMTGOy8RfvNDjOKXSMzr/7iVsM0WK13I5E92fOYJzW6+zAFhw5Ms+tbdfp/NLMnhGMwc69/kWmwe2Sh634UdHth4w1SBe339ezPLUI9qibAXH93aRnRYmi/PfP6TfNH5XJ+ld7Gl2emTf7Ft6gXmodTjd8t+cOkCwcc8v88fV1Vu87ZZ6FR+1Eg26B1845je9/2qGS8wTuMMVabFzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 09:33:32AM +0100, David Laight wrote:
> On Thu, 4 Jun 2026 10:05:52 -0400
> "Theodore Tso" <tytso@mit.edu> wrote:
> 
> ...
> > I suppose we could do it with kmalloc() with some flags which to
> > prevent forced reclaim / compaction, and if that fails, then fall back
> > to vmalloc().  Is there a better way?
> 
> There is already kvalloc().
> I'm not sure how hard that tries to get kmalloc() to succeed.

Please don't try to help.

