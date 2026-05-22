Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74889CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDA16B0095; Fri, 22 May 2026 06:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC5B6B0096; Fri, 22 May 2026 06:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9E16B0098; Fri, 22 May 2026 06:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD5D56B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:54:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57211C2B6B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:54:48 +0000 (UTC)
X-FDA: 84794747856.07.E9340C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A6BC41C000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:54:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkutECvS;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447286; a=rsa-sha256;
	cv=none;
	b=4x97YJVfzwYjkLq9eaWgl21+uNWyleFarsxpK61qdDF91LE5W0EoF8OIV7QWGCrECbdS0i
	eUY5bOpZHALAIZ/S0A9X9H1YPJvlv3ggrbH5hOBxzIrKXTNUtjhDede8S99fbd5EuJ0PTT
	22fzGCGoq/P5I6QDjFI3NN1SFkG4w7Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkutECvS;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AIOvztfUjkiBTbuolahgtGC2mZLONjW3VWKNqcGZNE=;
	b=hPC+NniT5LZiZ4FBqdBxOhLn9TMAJsxSDmgXQVXufKDBnmiCVkYfNYP1ToJ/nOCVlZ2TJb
	57Qp57bmSz52bqvewDnUISfj6kbfJLZxiYrmeb4a7fKY+Vn6Yn1b1rrsu8Li8+HC2Ulclj
	xiv7qsYy2o0HTgis3WTpfYjRKbI4VKU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2454360136;
	Fri, 22 May 2026 10:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492BD1F00A3D;
	Fri, 22 May 2026 10:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779447285;
	bh=5AIOvztfUjkiBTbuolahgtGC2mZLONjW3VWKNqcGZNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BkutECvSwEHWNWqVb7d0yLZr9hcjO0kBXD3BN8rCDMNZcYi14emZxpIJoAaB+Wrek
	 LCKFLn7rVFsnRp/x+5T4ztxayo8hBByKpGiXNCaDp2sJpVI43wxkIDnT571MtYfTlv
	 uP+HsH5/UQlampmc6Lsjq35VRu55LN4YBOukjk0ptGsfeF0G28CFO/OmkIlZCex1mU
	 9GSsJuaiTvRojjt4nZ3WW7vIirKQF13bhAL2W84u71L6VUQxH+8RjOzzZKlhNLyJ/M
	 6EiZdConJLPZtB+mefGs10+MM7T8WlS1KFTsV+N+OZwm8QZJsv5/XmZQTlfWYgHAG0
	 coeyBZmCO+dJg==
Date: Fri, 22 May 2026 11:54:38 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3 2/2] mm: shmem: refactor thpsize_shmem_enabled_show()
 with helper arrays
Message-ID: <ahA1zkl2U44GYVrz@lucifer>
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-3-ranxiaokai627@163.com>
 <ahAwLxwW3ki9cOjw@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahAwLxwW3ki9cOjw@lucifer>
X-Rspam-User: 
X-Rspamd-Queue-Id: A6BC41C000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 9fdcjq6crnera4e6r9gquzw99n81z5x3
X-HE-Tag: 1779447286-28981
X-HE-Meta: U2FsdGVkX1+heqTypiQX3cuO+4tPWACiMIacSuOjg0Uat6dFVTCmUp0ndJ1JMqkkxPlMyw7XtJGhbFUrqbjQ9mQoaAgjN9WFuDIPeTUD4dcYk6SuQtv8ODy51EMhJ2Gp9kliI6WB8zEz3yrgFTgqECoi/ExN/uFUJhuCjjhLozuNqsQVv9Yeb5GWz1/dDNt9NWGN8T2ASAeci1WndGloAtKzWa6uprTlz2QROwT8dImsUhDsFyN3H/rtqMy3HBRJVrjtEZEJFJ0YWGOWVOFWG8oAoNn3/GDoYGBq9C3YVL++6s5Ff3yV2htz9nx4W94wx4U/j60V987/cxMoKqE80zAnhnxIRU/hKglNpklpMDHB6VpU2GnJJfTo7UiClTJJ8cnYcF/skSBxdv9zLYQCgFhDFp6Q8VGEeyLqkvE+IDANfOK+mPTMEhkp9dJ2Hz3GYdiKUD3YPcN/z2Ngw5ENOaAmW8hsic6TWxLslh0iauqmpLh5EVXmCk0jX5XNUCuDTc6j+r+JDlnvaidYqx96AX3mOqcNw7qLJBEAbYFWdmFPfXMNKs3nBHohvTWXBrdqoa8RUP59LQeLG87aDWOiQYvqwsOBgVzh26AO3FRc3Od8lHeWy+ECKXVxTXN7XlqwPCndikPAkj8JIUUc1iYQk2lapRlQoHZgcf+/prNHtdxIM3lpJ7SXxTcXDoccsOu8TfDpMtgGMWagPi+OZGCrIJwM+id+qu++NspmnEwb5YliIjnp3h+NyU/SneGGo0dwaRQMz3pMOD6YbVWAAOvFOQlih5NW2GHb/XNUcQTrmAdJMlxTKPLmbTRhDi1Bmbwq4Ln09lXb/1yVQWgjBz3llMkKhWaK3t7YGQSQOe2q+bZiEqsJWnlyr8QqTTuQr8W/wMWcVhpiN5fN53/FLFh6TPwAwZB41v3BTYzo0q0OQxhaXPVOsu5tKwMP3mXdCRYAhB9z6tsT3WB2VRuRc8P
 uKHbmP75
 /ajo1ykw3cF+lWAmSfWOb2ZCV9GOcMZUYlhSn7k1UfTG14pXNMU+Iz1OmLr8NFvLk6qj/9h8qpgxFGVkpODh+yEQ03EpIzTR7Q62KfGl7G89m0CX1N/y8cOWNRgWX3xAOtRjVq08ecHA/Iv9aVYxC3aT8jQHNWUnEsywuQQLSXN0UC1GTXyT/a/hY1OWg85E91zOdeYatkh8+AMVtPKy4cgDcv+Ecv4poqMgi3IChyzw3EMAaiIxda99XmQupDkjTEPN9hqMToH5XvOZz+ggXWtYYfTitXMrPb6KjQCuz8EilnVBAEk9rTGRmQ+SIUqZ5gMSYB2D3WrOx6ZV+iuvLXky83TsSw33vAZNmUenUo5LmIPR+jgv6K14hihPKwCNR1m8wQ45yK1YnnoZmzzt/hdSYivHAVA3ylvCbhAIiGf9AITZW21w1Ga1No8h+Mr1pWELHf57JHfbxxAee7MycQ6dbhWT7pM9BHM/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 11:35:01AM +0100, Lorenzo Stoakes wrote:
> On Mon, May 18, 2026 at 12:32:38PM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Replace the hardcoded if/else chain of test_bit() calls and string
> > literals in thpsize_shmem_enabled_show() with a loop over
> > huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
> >
> > This makes thpsize_shmem_enabled_show() consistent with
> > thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
> >
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> From: ranxiaokai627@163.com
>
> This does not match the From: field of the email.
>
> This is violating kernel process. See
> https://docs.kernel.org/process/submitting-patches.html
>
> Please either update this to your 163 email account or resend from your
> zte.com.cn address, otherwise we can't take this.

Apologies - I'm apparently blind :)

You provided this in-body, there's no issue, ignore this!

Thanks, Lorenzo

>
> Cheers, Lorenzo
>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Reviewed-by: Breno Leitao <leitao@debian.org>
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/shmem.c | 36 +++++++++++++++++++++++-------------
> >  1 file changed, 23 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 46d2cfc30823..197c9cc314c5 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
> >  					  struct kobj_attribute *attr, char *buf)
> >  {
> >  	int order = to_thpsize(kobj)->order;
> > -	const char *output;
> > -
> > -	if (test_bit(order, &huge_shmem_orders_always))
> > -		output = "[always] inherit within_size advise never";
> > -	else if (test_bit(order, &huge_shmem_orders_inherit))
> > -		output = "always [inherit] within_size advise never";
> > -	else if (test_bit(order, &huge_shmem_orders_within_size))
> > -		output = "always inherit [within_size] advise never";
> > -	else if (test_bit(order, &huge_shmem_orders_madvise))
> > -		output = "always inherit within_size [advise] never";
> > -	else
> > -		output = "always inherit within_size advise [never]";
> > +	int active = HUGE_SHMEM_ENABLED_NEVER;
> > +	int len = 0;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
> > +		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
> > +			active = i;
> > +			break;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
> > +		if (i == active)
> > +			len += sysfs_emit_at(buf, len, "[%s] ",
> > +					     huge_shmem_enabled_mode_strings[i]);
> > +		else
> > +			len += sysfs_emit_at(buf, len, "%s ",
> > +					     huge_shmem_enabled_mode_strings[i]);
> > +	}
> > +
> > +	/* Replace trailing space with newline */
> > +	buf[len - 1] = '\n';
> >
> > -	return sysfs_emit(buf, "%s\n", output);
> > +	return len;
> >  }
> >
> >  static bool set_shmem_enabled_mode(int order, enum huge_shmem_enabled_mode mode)
> > --
> > 2.25.1
> >
> >

