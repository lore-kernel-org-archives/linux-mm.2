Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F077C10F285E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6736B008C; Fri, 27 Mar 2026 13:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596436B0095; Fri, 27 Mar 2026 13:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D32A6B0096; Fri, 27 Mar 2026 13:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6726B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:14:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FEB81611C7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:14:56 +0000 (UTC)
X-FDA: 84592492992.02.6FBCDC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D59E9C0010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:14:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vE8oNNh3;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774631694; a=rsa-sha256;
	cv=none;
	b=TQpM9APIR6yhtQmqQUwO4E1j4QThgZT67ZIAKclPIsXEMqjdui0PHd/thk25r3L1vnS9iH
	hQt061d4Rh2ELbzRHrnmi4q18JYTZrgembY0uqLVBu+BrBzu8oxr8ujr2UWBTSSvmc4HXC
	maZRwxMtTAHw0ajSpqJNSQFfIqnNsxk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vE8oNNh3;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774631694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iz8+WBZJ2fcV0EXh6JBXT9vQKai1w3MQ87DSFL6wDM0=;
	b=EbkB6sGK9OtqiCAUN7PB29/Gr2BZ2vwL5KvhYpKsxNcybkbthJ4hStqdXqtCR+CgmyWPJq
	ESmSmrTtKUc7K888YG0PDDyRUX4lK1CoB/l3Fj+6h4lLmcjhiqg5uV2nbK9HLFuqSlU5uT
	LDyDiTsvGMGUJjXRj93Wfdoz1tg7Bgo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D09860130;
	Fri, 27 Mar 2026 17:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB704C2BC9E;
	Fri, 27 Mar 2026 17:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774631693;
	bh=Svg7iepPXn0m1m7+3rVpJxfIlKO/FRjQeoIGNYLvQnM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vE8oNNh3iB8xYd1eepih/lmZ4QquBz9eEAkAUIl/YXkJmmDpw1AozOYgh1w3uoCdd
	 QsjKJbpSTEgGWF5ughy2EZBsEtrGlkpACtXK6uU5eoR9nXA1XcqUCabVfrmhZ6UBE7
	 gWW1kaUaG63jUK3JpVQBlPF6w2+rCLfNmPCS9igU=
Date: Fri, 27 Mar 2026 10:14:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 dmatlack@google.com, pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v3 10/10] liveupdate: Defer file handler module
 refcounting to active sessions
Message-Id: <20260327101453.dc4961b803cf74d43d477dfd@linux-foundation.org>
In-Reply-To: <20260327033335.696621-11-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-11-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 36jqnrob7mca8up746ifa9uome5r76i7
X-Rspamd-Queue-Id: D59E9C0010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774631694-802818
X-HE-Meta: U2FsdGVkX1+HMdTa8ESQfqPC1n9PadRl/nXMiQ7XnVQuFvXOZQw/ei5S+SscVm5Ydy3b+GE36RPUYSEBrjCqzi54sUe7u+L7wlbi1TzhHVzpu/nUm5yOwfgTgq3WqdehH7OOHN/L+o18rN6oeP0/nkfruXY5dxgGVVSFiJ5ZTPFGNK2J5SwAhSGVAcsmpXzd9dtUUik132G4JpZKGbXr4vKwpBxt7wRqABS6tOQNExIBJMWA4eOzKXQ/bk9qoNVY4kfPdDpEWAye2AtGMXYIbGqWAyJY+2+uNIBKTVf0rWv5SR1PT2eW1C23rK28Uqp14d1kmyhM04Tgf2K5LPV11KgerDjjK8MB7SCvI4Vbb1fPwT7mvqsFITagcjl6UK1I2KYxOuPsBqfh7w4ghjdIIQM6Oh9G+zVU0eFb99ikXXyWjLikEMots8yWno99tr3bh7RHM6fk0/4nCJqkrfTq066FLEvXHt0Io23oiVlIhFwhA61NZZhMNVW6UjLrZzAJdshllzSMNSbpYCfzvQ1ZF3bv1dP3wIYZZmbBdERWYEjPmDAcXMo8YO4SVYvpmikKtqGOIRBbGVsjdaVk1v721Nvq1SUf7dqY8FsJZn3XE/YDpkfgrOlX6TdjS/XMF18phIZj+HqUIiPHzt+LMTzKAqsoYwUWmFgSb3KSV3pak5CvUHgfasLHtQUWZJAZXrcYKNvDbf91JqBL6v61HQHr6ezz2fptnhMrYrPD8U1XJvtYNQ1JNvlnN+7u4jF7fQvCvD8CHaPontVb//41/VgH4P/vFeSxU6t4pInG83LcZ6qCojV4FVhsslD3ELKx1Pv+jM9kC7rjjDfDQ/zKyS+OzZCQleMAKj0AKBC5cG9ZPjdrmKGETFfxPG9gq4Wkk1nD8m3X9oGPf0DdDUHmu8JmCNBnQnFwi91ufz4R2849uVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 03:33:34 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Stop pinning modules indefinitely upon file handler registration.
> Instead, dynamically increment the module reference count only when a
> live update session actively uses the file handler (e.g., during
> preservation or deserialization), and release it when the session ends.
> 
> This allows modules providing live update handlers to be gracefully
> unloaded when no live update is in progress.
> 
> ...
>
> @@ -322,6 +323,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	kfree(luo_file);
>  err_flb_unpreserve:
>  	luo_flb_file_unpreserve(fh);
> +err_module_put:
> +	module_put(fh->ops->owner);
>  err_free_files_mem:
>  	luo_free_files_mem(file_set);
>  err_fput:

This didn't anticipate your "liveupdate: prevent double management of
files".  I resolved it thusly:

err_kfree:
	kfree(luo_file);
err_flb_unpreserve:
	luo_flb_file_unpreserve(fh);
err_erase_xa:
	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
err_module_put:
	module_put(fh->ops->owner);
err_free_files_mem:
	luo_free_files_mem(file_set);
err_fput:
	fput(file);

	return err;
}



