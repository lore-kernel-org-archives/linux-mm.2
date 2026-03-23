Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D66ED58CAB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 03:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ECB96B0005; Sun, 22 Mar 2026 23:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676296B0088; Sun, 22 Mar 2026 23:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E1B6B0089; Sun, 22 Mar 2026 23:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F82D6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:21:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5C41BBEB7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:21:33 +0000 (UTC)
X-FDA: 84575877666.18.CC3657C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 648DB140003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:21:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NOI/EzAI";
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774236092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRwkYLYyO8q6WWNTg48brkFByTgN0JR6z4WTvpCGOMc=;
	b=I9Rw4J6dHzjFIIDNF4DkqKoqnmfUhoDmTN18xBGDwhHxQvXL1tHt5Q7P3neMzh6Vxm5DlA
	mvQV7rPodp7ggzEnICa+M1d1+ApJVjCzKazqor71werQ5t9mEcuW86yI1CYpQhRroZdur1
	mJt7rfUpuWwZ6kTtKU+gj57dczffy5c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NOI/EzAI";
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774236092; a=rsa-sha256;
	cv=none;
	b=VnAnCCmGEoy0NIi7xbp9elY8mw1KXEecACiW2lWQbS8TIm+U9GhgrADwWVwamWRCIoh/do
	r2vn0AzERhXqjQ8mSg/viegImieli60WJktc+C0WT0C8qTqk8JRgwL1rTQQRNysFsKOc1K
	8EToyAA6VxqGOtmH0xPdw92MCsSsyv0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774236089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aRwkYLYyO8q6WWNTg48brkFByTgN0JR6z4WTvpCGOMc=;
	b=NOI/EzAI/+6XZJBCTugg7FZRuqXn1jkMtTiW+E4B+eNK6wCxTZF4sYACjE0bayi5t80bpl
	lAFxg6MLuDVNEdKvkeVVOK+uJdrvd9naWUqi/dTfHYY/e3etOwEyz24fABqFLccfxO+1zW
	1BFJBPJDR7YIgQozMgD7yCjih5qEUO8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-116-jiOunJ4JP1yFOLulXAHucg-1; Sun,
 22 Mar 2026 23:21:26 -0400
X-MC-Unique: jiOunJ4JP1yFOLulXAHucg-1
X-Mimecast-MFC-AGG-ID: jiOunJ4JP1yFOLulXAHucg_1774236083
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F1B119560AA;
	Mon, 23 Mar 2026 03:21:23 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.175])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42154300019F;
	Mon, 23 Mar 2026 03:21:13 +0000 (UTC)
Date: Mon, 23 Mar 2026 11:21:08 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v4 0/5] selftests/mm: skip several tests when thp is not
 available
Message-ID: <acCxpF5l_lveG2MD@gmail.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319194604.0a9a733f521caf2dc2bf18c8@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260319194604.0a9a733f521caf2dc2bf18c8@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: DSF1T3EiJsq3DxG08BMcxQlKM9qS5suKpk3VTab8qsA_1774236083
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 648DB140003
X-Stat-Signature: yan5pqyjpfqg4eamz8bxcqjiztmw395e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774236090-848503
X-HE-Meta: U2FsdGVkX1+yuf0lkar+bn+tXsCMO3rRrHeEg2DvKHbwA2I9o3YPOXdHS7ZIkxt7W0JW2saZumJ+DCLKrK3Kqr5UEx/lsB3YyykjSuk/SS2FUQoLdYpsTsD1Zc6uzN1ohGu2Ef1QvcAgUrQniODLXb1qqoZaA/5aa84iAsspvL+k+g45JeNiiM5ozMgA6s/poXpKOCYeguMBCothUMqTkS+D6M5R4IGMH8VfAPuSKiGWJ35wKzvccuUfFsBQLcG/RdAm/VYDDuk6P1clJCOY/5AQIxSTeGra2QK2zIWYlGN2nbJ912KeCGegRSPxLgMu+ikDC9OCOBNjW5b/QMHBYZAWmzcddjpeA5QGVb+a/IQX9SKjBJVk0P4rT7gSQtyDpqPAb2LrHhjJSMPZwx0qjUKnCS3djCKIXYmIiGA2dwkAaat0lBEiEqr0ShJhNMo3niPcgboC+9/Ka1bNfjoyL36UWbGnL3P6Ls3stSU1DtmF9TScuTxOeTjf0qK7j5GbKk1hEhwLRrNGiwS5aR5lLlBejPAW6wHkXiPs5BdCJ9+3+wcJj3VIGFcc0DDDDaRnlrt7QzD6H9VGYHWIHOF0ml3SvZiAl2RwNCho/ix9/m97xmjge9bOBg6aX3skhwoO719yeX79jteK/agSlrOYTiVn+Codw7TVE+NN9sLnwIty/s688teq4s03ObTzx18BXG1yd8gXKEjlJ4S0MM2luIwHcROV4xXCyEckogjkeDT/I5ETBI4f7pOGRFjEGvzbv593KLd/FYkuKpH+hlbuz1XJYvlz+f/lKJKLd07EFn4Zj6+BrjyfB+76HiKccGrk0qi5WlZXzxmTKYlNu4SH4fhFTJzKJylFmpY223x0NWjM8lxFTx4uME2Pq+cGFYYmj/p1Q+eHD52mTlgb31Iovvmxals3azI7oIzPpH1wtDdSoagq1pxKr0sFkruuMYsGmY+PlQtv/oAhbtLE7GH
 w6SN+JrG
 matRZIXKBqkBiuNcWkhQFHKcGbJaHe44MrAJjffpeebPeKFjN/7VIcZ/2MuZjTNPaqkqGLV7LdZBS0agodSBS8k4H7gpl5aDw1tuVrNRmEtlZ7gZqFZ0ZRSytzHQSag4Epz5KdIESkcZI126q2cqp0Gp5ItS4aU9kgbdbUqH3NpogMUqFR5epKMFo21oxcM80Ruh873A0naGgWWtUy2YucUS+uyL+wctoPV+q8OkmbE/G+xCb2rq1VyBmWWKgrE0r/SxGyTwM0j9ZeKSXnq5I9+vDkewIasVvxQGzQ54U9ZgM07dJ5jj+MLRbPE89SXQZNWw74UQlzoweYq2lC8WMquhKTG0Mi7SjxC519a/Y3vsSu5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 07:46:04PM -0700, Andrew Morton wrote:
> On Fri, 20 Mar 2026 00:06:51 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > There are several tests requires transprarent hugepages, when run on thp
> > disabled kernel such as realtime kernel, there will be false negative.
> > Mark those tests as skip when thp is not available.
> 
> A couple of questions from Sashiko:
> 	https://sashiko.dev/#/patchset/20260319160656.1480279-1-chuhu%40redhat.com
> 

AI question one:
```
> +void write_file(const char *path, const char *buf, size_t buflen)
> +{
> +	int fd;
> +	ssize_t numwritten;
> +
> +	fd = open(path, O_WRONLY);
> +	if (fd == -1)
> +		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> +
> +	numwritten = write(fd, buf, buflen - 1);
Is it safe to keep the buflen - 1 behavior in a shared generic utility?
Since this is now a generic API in vm_util, callers passing the exact buffer
size (like sizeof(buf) or strlen(buf)) will suffer a 1-byte data truncation.
Additionally, if a caller passes buflen = 0, buflen - 1 will underflow,
causing write() to attempt writing an invalid size.
```

Here I think there's no single anwser. We can use buflen, but if user don't
provide a '\0' in the end of buffer, out of boundary access could happen
when such as printf(). We called it buflen, then we expect it's a '\0'
ended buffer as I undersand. So maye we can just leave as it is and user
should be awared of the requiremnt of the helper here.


AI question two:
```
> +	close(fd);
> +	if (numwritten < 1)
> +		ksft_exit_fail_msg("Write failed\n");

Does this drop useful debugging context compared to the previous version
in thp_settings.c?
The old implementation printed the buffer contents on failure. With this
generic message, if a test fails to write, it will only print "Write failed"
without indicating which file path failed, what data was being written, or
the underlying errno.
```

That makes sense, indeed we dropped the printing of the buffer content
compared with the version in the thp_settings.c. I can append a new
patch in v5 to improve this, together with other safety checks.



