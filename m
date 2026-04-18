Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6590BF99C6D
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 00:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6516B0161; Fri, 17 Apr 2026 20:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666546B0162; Fri, 17 Apr 2026 20:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BCD6B0163; Fri, 17 Apr 2026 20:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4744F6B0161
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:15:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4A1913A939
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:15:18 +0000 (UTC)
X-FDA: 84669757116.11.3848B68
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf02.hostedemail.com (Postfix) with ESMTP id C948F80013
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:15:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DFoFh3u+;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf02.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776471317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jWPUsYlvbemv6wULx8VhAx6W3qWmNB/aw/dH7b5KFE=;
	b=qCo239SFRcUPDyJrV3S/kD+dPTcSI8vQdj4ofASOXs48oTBtSm0s4HUIYiuk/rQ7gW08wJ
	dcdPaJQPLDjo4BKF/i5Of+c0//wp4xyCxbcayUsdmefZShoi4v9pYN1n3TOS+K9HGfDCZ7
	KqsUJex1M3iY5K3cvvPzMlsKbz1g3PM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DFoFh3u+;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf02.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776471317; a=rsa-sha256;
	cv=pass;
	b=coX7ta5Fz4ntFcM9jXwkgyVuGWvAFNArSJLb7Y78Xrfm16DdP6RWSfrUfXcmFEnZhVcLcG
	OQq1s3hS8DM7kJ+CLsoki1sercUOhJpPbk2KTKhvXdWze0CEwLA7rZi04r++5kqAiQlZDE
	FVOE01Ne5MRVETp6RE1MEMmWoom7FY4=
ARC-Seal: i=1; a=rsa-sha256; t=1776471290; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Guxlyh80DUt5ICo+KhSeU3676tMSDH9CFL98AfYGyzbs/1quPtnPwJte9LxhfspBKE82m3fqqnYrShlQOwpm41CYfUQR56GY2Es13UYJyECfNBvKIS4bGyMrwN22HkZJzP/+fayfcv2C8cFUqr5c+1537FR15r8CbGFPTxVgI64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1776471290; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=1jWPUsYlvbemv6wULx8VhAx6W3qWmNB/aw/dH7b5KFE=; 
	b=AITidAhJa7MjgrXI9iIs6qohh+eG/6zs6XkWg8WhIvDhYHCTXe2WhX32FjscRLWOyBr/3ESAxHndu+9TkDCb9Y4e3RaHZh9rlLmkJYDOSAtbAZJgQcWd2C5WyJnp7/xSJ3KrklmiUzCsto+KH9NFshMOa0fC1ze6+GTxJKHvNAg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776471289;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=1jWPUsYlvbemv6wULx8VhAx6W3qWmNB/aw/dH7b5KFE=;
	b=DFoFh3u+Oy3JSKEGqQgTbR/0ph2NvmBF+topU5NXh0RlMxS1JyAOK7Xoa3ZaKxc4
	MA3saTdRV/IfhE6D+ofo4448TfIZhsSb9dJA4JOtAtaWYY/En0+hSi8ynXwSLdwQsTW
	nQPUAQx0H/BtZqDIHF7kQrpbmVjRiiWJOngb4yzQ=
Received: by mx.zohomail.com with SMTPS id 1776471286964358.79542544682465;
	Fri, 17 Apr 2026 17:14:46 -0700 (PDT)
Date: Fri, 17 Apr 2026 17:14:45 -0700
From: Deborah Brouwer <deborah.brouwer@collabora.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Alvin Sun <alvin.sun@linux.dev>, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Tamir Duberstein <tamird@kernel.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 1/4] rust: sizes: add SZ_4G constant
Message-ID: <aeLM9fB_LtCjbBrw@um790>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
 <DHV3SQ191564.3FMK513OJUMKV@nvidia.com>
 <cb3dd598-04f8-486c-ba6b-9965d93170a0@linux.dev>
 <DHVHKSI90H02.143VLYN9JY4FZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DHVHKSI90H02.143VLYN9JY4FZ@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C948F80013
X-Stat-Signature: uwim47eb9me1do8eaigyx9jgn5hekns8
X-Rspam-User: 
X-HE-Tag: 1776471316-87477
X-HE-Meta: U2FsdGVkX1+q3r2lyc1P4krAjeq1edVGQ10iWffzPRr2qqh8l1gsadeyBb84BHVASTI3qKstYkHfm85NNlFaxF7b0ydklAcjjeW9boH/VNxSp6TL2PUBVgLsu6NNT8yIZZ9vIih7ow5NUvRKlI/3GID4YDPK4HQZJeIE9uMv/0jGcRuUgDjNrvQPvPWnjLz8i2vSQTCy+YmPacLpSsswlW0kH/eyuZ4duD/YlUlvL+XSRE0i2uFLk5v9BQ72LI9CZO+e6zMSpgeMUZN9k8wu03RfK60FJNP715xVnCDY35nHBEjozZK2YNDdz+u7teIgBkgBSjwW5aMk3xqA7IFU7juGyss+Y78bfRmtc8fnJTNa8ewLQ0AvX7SuXn/7Oukh5gpMHPBJRf1N8iVN7XRTcBq5TpJoJeRjEkiubjY0HdrlS++ft0sN/2lOxlHQy09kMDmWrvm2EkxR1pVxyDvVD34IyWMfjb1MYbaYSNtCJ4ATKYqeTEsOzT/0pDA+QEXF8WX4mrGl1jJPzx49c/mBGzoJe7KI+nKfeu9asKgyWVoS4K1lbjLQ75GZ7J1pfpGbRnnCu+AwfC1qBlMwlBZTkfbJ5O1pO3mfjt9/keh4Ajd17ZhGizqb+d5jqTUoRYG/bupxrTQ/zw4XNpdxfDJxgTKapU41QbZqK9705un/UooewGvR1xGcM8ghslTfs4PUs1bCUM4l5K8PSstydzzfc906pzxIaI2UlJXIcuaQgWs433ICjF+gEhNWztpmTCE5/t44xY23e+53ytlh5yOpck1p/sQbpvSvcwy2iScw9cgrW0RJk8DtqP7W1pNj8Pzvtu6uc6mt7vNaRbpQr8m0n6T0PG+9Ubyqn6W1E41NXFzcupaqCjkIuexA6ilyzXE/C9OuzVBPFnxMxlW6/eqF8Cy49AUNxH6oXHLj7mWurPQW58dMioh/i/Fv4nvyQ1pTawrVaHPYvZJPkn93X0Z
 1KbsEl9/
 LDY+zviG8/ACDod1Kzw/a726gt4SPdFHEJaPP2kEIwi1VfOOzjOm0p8hPcS6aTVeCJCoVWNO12tJtaoWkwygiu5g1cT9dJfTirNc9DTHLm3sBzLeovn9uHaUS+kug5ZYb14rl8QViIgg+EBhla5W7R5xxR23bjn6IsKLG+m8t3hIVpgaRn7nyNo+Kp8UlEUES2kB0j0oXC/6rJdYoHNDuEIx4vAedcxkhdqQ+nHYKdhhSOhWmDxINKycIJ3mfufht7/EJS+sZLcFreu0VJuIGkWZSD7c8mBENWjeLl9lv85SkkXgAk3DTVoZZLTNlCPQPoaHkaP5+lp352paeEWENPUVEa6IB+nKgwDBMpgooNQe32A8ShMblVrv0ighUPsf1XgLU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 11:06:30PM +0900, Alexandre Courbot wrote:
> On Fri Apr 17, 2026 at 8:56 PM JST, Alvin Sun wrote:
> >> Finally, maybe I missed something but the new value doesn't appear to be
> >> used by this series?
> > This patchset is a prerequisite for the Tyr ioctls patchset [2] that I'm
> > currently developing, which hasn't been submitted to the list yet.
> 
> Why not have this patch in the series that actually makes use of it?
> It's a bit confusing to see code merged without any clear user in the
> same context.

Ah sorry I suggested this to Alvin since his Tyr patch series that uses
SZ_4G depends on so many other patches series that could change out
from under him. And I thought it was general enough that we could get it
in place before hand or at least get some early feedback.

But either way is fine of course.

Thanks
Deborah


