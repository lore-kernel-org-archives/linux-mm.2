Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 563C7F3D5FE
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 09:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3836B008C; Sun, 29 Mar 2026 05:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3CE6B0095; Sun, 29 Mar 2026 05:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692196B0096; Sun, 29 Mar 2026 05:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 527276B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 05:21:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9C971A03BB
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:21:38 +0000 (UTC)
X-FDA: 84598557876.01.E9E0494
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id ECAE820003
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:21:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RYndpH1Z;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774776097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PqKdnWYBl+3MLXiN4FswCOj05Ubop0U+aeuFYzD6Zo=;
	b=8cbk2a5Ohg08lyA0qRiKKYpSf0h1p27WxhEGsPM7dXtBOYVOqsHXDMY72FN9kVFpaAopFe
	cCtN0xB+GjgVaYAvXqPVRcJLlHCG1ChKwTmewvTncA2uVgl7bfHoCrOQOhaUOhy0gIX078
	r72myRal0mKHBpDbTDA++ALJmTMQgvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774776097; a=rsa-sha256;
	cv=none;
	b=El3SVGkOJr8oUrkU8XG8F1wuXjR8PTt3BSn+I9v2NeOB6MqWTLXpQRF7GXGvShH6Yhr2ta
	BoLwJtJAxPFlkXbkGTKUvrrvlJMTNQSQDXUhZceiNE6bPImfhnxDQMtxKoJXth6119gJIk
	yxhUn3+hyPkIsJQ5TgyuXlxw+/2lIuM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RYndpH1Z;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774776096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/PqKdnWYBl+3MLXiN4FswCOj05Ubop0U+aeuFYzD6Zo=;
	b=RYndpH1ZO3yPpHG5XvfsyT167uArolsdYZDKCkN4J40a77kBHFr+9AWp4sfSaUljK3gIKx
	zjTiy6PDz32mNvubk1FiqkDr2GK4JY0aSzqcP1ye8aqgblyprhF0S2Aj1ABCFyT40F5Q+Y
	cI0j1Ja9cRblC5JCMdFQhKVJqfKBWt0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-D--kvJZ5Md-wWk-tpjIpQQ-1; Sun,
 29 Mar 2026 05:21:32 -0400
X-MC-Unique: D--kvJZ5Md-wWk-tpjIpQQ-1
X-Mimecast-MFC-AGG-ID: D--kvJZ5Md-wWk-tpjIpQQ_1774776090
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DFE2195608D;
	Sun, 29 Mar 2026 09:21:29 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.11])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9FD3180036E;
	Sun, 29 Mar 2026 09:21:19 +0000 (UTC)
Date: Sun, 29 Mar 2026 17:21:14 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <acjvCmSUV2b2ltLM@gmail.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-5-chuhu@redhat.com>
 <20260326230349.dcd0b30030c7d460e8b0f319@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260326230349.dcd0b30030c7d460e8b0f319@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: YpJ_aaq2d0t4AY0pRpJNOkiX6L7-k5sScQoX3UfdTGs_1774776090
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: zwo3hkwqcdg9tmgapwaa35p787ob4m8a
X-Rspamd-Queue-Id: ECAE820003
X-Rspam-User: 
X-HE-Tag: 1774776096-628990
X-HE-Meta: U2FsdGVkX1+tsLhFBp32mLpwkgJ1paNnjklAwsMgOv7PiIdWU0T90CES4M5Rdv+U9lhA48ihE8HnHRBnTH3eRe4ahkOisbOUa2/fWkieykOc2IV8PBWCwuaPjif7rSfzK/bSeDMkqCcq/XU5IhLIdy4FCH4T9/vRSjj3+i9AI/fY9sTgYo7i+FbLLfIS5V8maO9IPoylkFyJhIF2I2041RCw6azJsSGCzxLaHbXnB8KmZBsITjPO3YgGUOkc0jbdMx8MmyLdD7JuzZt1HOd6ysUrMG1OEu4VAJTeie55s/j+2ksU7uWsFpXHgNJ+DRZ4fxaWWDHSNcyuTrYCFRzvxWSOLMP1ctktxLpEm+O7kXs9UtC0tItY0pZOhdfgErXqQXuPvQJGECV8SteUTY6pMng/6+pE5LVTDmn6TQOklQbq2j6yOMtrDxOEZyhXzsaW4anV401fz3JmVWNhLfNJjF+6qiQW7U31YMAJLfxnJa4wKnDZEGyJupr+6g0Vt+2pX3L5YwoM1QkbVmlRquPrNO1PgeMQRvDFutyjrLn7xvQyIQspK0Msmt2519vM2gYygRggmPZfG0Z5hI+fF5obW5KRvJnmczHZZglOc+f84iYVG9hwl1GyHEyu3teZKmCEyMi3yI2i3oT+3kb0hZSRV2xZKQrUe0Y2FwGkwB3HFeShvqWH2GctvhsNnPlWUpmGvFLpN6V5qpt1TPqTzf7FFBlAVN26ZMuBS3ZxAwdf/BeENHnXzfSgwtdavOt2vrvYPwo4ZjDLy1jOxxMZLpmV5LtnuhUSrU2C0chUBj88JUelUsASkwGeX8WuDz5pJlyKwYdWlOWlsGzMhglRSGTG1bncdtS6hDHBpcr4BIGFqQK0gM3nahqFnFwVhOnRFGVCMRw1kcCeGK0d3gb+oqJoyTBLGcEy3Da17NXq2E4pOBHzwhpL/E70mlNrZbgFL0yKj9WG2RwgFkM86YvzJ7/
 FcUBmiBj
 GkOHRFj8DHUti8+kJ+jnkv4fjytk4KJhFpDhikLVBm86SxDcVsjle9wNqNIWyHmqQ9xLv6kkvhNDbeoJqr5CbE55yamHApOwyZQSynah7P+W4PY/SPIa5LIksmElHnqwlQAlOH9aNbr22m72gCUPp3Wi8KLlY8OdYBvrjkhNx2YiBMExzf1nuaIujUJcN3tjk5XZIL2LQ5cFVTPWdgGqdeASZnQMlmQpSJgsPQwX8sJvn7iitJA/XeEqa71P7LaEcSRB92Pa+98KOX5Z4GA+xSTiRJXW27k6J/MzGkZN4OIY62HcDSUACcX8TAH0m+v7uVVKc7mih1cAC0b2Z54TXJ0804QMrh58ntVJGT71b7rI1F0xkzhUK8ZzmlM1/9bbdFF9aPs93jyB4p/FGjrpGnU5N0jwGQAH14ULM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:03:49PM -0700, Andrew Morton wrote:
> On Tue, 24 Mar 2026 09:33:14 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > Add two more checks for buflen and numwritten. The buflen should be at
> > least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> > The numwritten should be equal to 'buflen - 1'. The test will exit if
> > any of these conditions aren't met.
> > 
> > Additionally, add more print information when a write failure occurs or
> > a truncated write happens, providing clearer diagnostics.
> 
> This one has no review and AI review did identify a kinda-bug.  Maybe
> nobody calls write_file() with buflen==1, but still worth addressing I
> think.
> 
> https://sashiko.dev/#/patchset/20260324013316.2590422-1-chuhu%40redhat.com
> 
> Chunyu, could you please take a look?

Andrew,

By limiting the buflen at least 2, it will avoid such an issue, this is
also suggested by Lorenzo. I'll fix this in next version. 

AI question about that we need to handle error path and trucate path
(numwritten < 0) and (numwritten < buflen -1) seperately.  That makes
sense. I'll handle that in next version.

"""
> +	if (numwritten != buflen - 1)
> +		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
> +				path, buf, buflen - 1, numwritten);
>  }
This isn't a bug, but the new error messages here and above use %s to
format buf. Since the API requires an explicit buflen parameter and writes
buflen - 1 bytes, does using %s risk out-of-bounds reads if a caller
passes a buffer that is not null-terminated?
Would it be safer to use a precision specifier like %.*s and pass
(int)(buflen - 1) as the length to safely print the exact contents intended
to be written?
"""

That makes sense, I'll use %.*s instead for the buf print in next
version.

> 
> Thanks.
> 


