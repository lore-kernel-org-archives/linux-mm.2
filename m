Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686D8D58CC7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 03:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4846B0089; Sun, 22 Mar 2026 23:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C306B008A; Sun, 22 Mar 2026 23:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D88C6B008C; Sun, 22 Mar 2026 23:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4346B0089
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:11:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C732BBF6D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:11:19 +0000 (UTC)
X-FDA: 84575851878.30.01DC420
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 18E4F40012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:11:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Nj/gU9Z9";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774235477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EisQwFemUONm3eFuD9fzaWUikQLN9S4IonXmw2NBtMs=;
	b=5lVpbFRgyl5Kz6BOZnntiqDvM1CcXI4OK95qvChrtBq4m8Y8hQZMB8ZnI9Ulbn3aEQ144L
	vJQT7U3l4V42g68HT7/16RQdNsYAr/6Ymyzl9IQF+XEDVrwiePn2PjH4ldAIO2i0fMswyb
	B0FfK+13pDOKU5OOuFLshlC3sqyDZHs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Nj/gU9Z9";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774235477; a=rsa-sha256;
	cv=none;
	b=qJDAei8pWorNwTqKsMYLzh5ObMGDsOOwcX2U1GeTUHr+FJw/ugM8sJpnLwEZHJ/W+MEUCd
	lAKJiGH0ofkna9X9CBkIIRWztLALqJof9WDng/KF0/ghUofJ2mXkJ+kFjlsvbWFkSwT5rK
	9dJbs6CHKzO19pf227f2cz4f5zsEoLc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774235476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EisQwFemUONm3eFuD9fzaWUikQLN9S4IonXmw2NBtMs=;
	b=Nj/gU9Z9L07UD2bDAVnAh+tKEC/Y1Ony9+pUq0QVXmJrxsxoIjdYxsqfOsg71kWeiROhpt
	pCp6yI51PjFjMcAdwfOv5ATeziaNCefRfF10BKynTekUZUPsBgyQcAba/xqqpEWdd+eEYa
	kK/WtFPC5+W3k9YfEIA4ScWlYa8MQL8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-IGVfM-gtOxu5FC31Js5uWQ-1; Sun,
 22 Mar 2026 23:11:12 -0400
X-MC-Unique: IGVfM-gtOxu5FC31Js5uWQ-1
X-Mimecast-MFC-AGG-ID: IGVfM-gtOxu5FC31Js5uWQ_1774235470
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2423195604F;
	Mon, 23 Mar 2026 03:11:09 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.175])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54AD71955D71;
	Mon, 23 Mar 2026 03:10:58 +0000 (UTC)
Date: Mon, 23 Mar 2026 11:10:54 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v4 3/5] selftests/mm: move write_file helper to vm_util
Message-ID: <acCvPrjndaJoSnF-@gmail.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319160656.1480279-4-chuhu@redhat.com>
 <78352e6f-fa40-41ee-b044-62f682f3ca43@kernel.org>
MIME-Version: 1.0
In-Reply-To: <78352e6f-fa40-41ee-b044-62f682f3ca43@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Bj2MWj-bO0FtzGmOR02nO27MzB50wE0vQhipR3mlHxM_1774235470
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18E4F40012
X-Stat-Signature: 9cp5ux3fiqgubbdxzbpjb4s1go64bniz
X-Rspam-User: 
X-HE-Tag: 1774235476-755480
X-HE-Meta: U2FsdGVkX18cCDV9vaFV1YY2OlIP13jfukrW1tVooCPW7afqrmQx7Zp69lhC2v08f1gC5y5TCTJghJlCuik4jA4yqAynJF1LIioyM1qb16sgbZ6tExjw7GKQh7WtAxb/z+Agjc6ddf6XwcuV3KqdF2JfKJXXooXovU2zR6YcGbqV+L3qbK7+x22lMM4oS2xelz6ORPe3PGsMxk6oj1RfH5c+Nuw7s64dW84+6cjezKzek5EGt3z4ttlgsRp13bMwls8TMv4dpbp788M/K37jybkByYhLhly2a7J1pv/sTazAZl8oPxvb3YvP7Eh7Otp6QWpl8QeU2lS3hg1PnUX/lkn1oVrHpqBXdZlBZQgwhMIM6NmEHGqa0zQM9Ss00ZS8u+Px2LgX/Udm+gFVVueH2iNCe5ARzlWNJ8tKPn3h6lVaPlxBEu0VCqVoPmRcQbVyKFQsvqK2/w+v5LwAskERt8ugPpRpg3smo77zI3zsydWiq3DCtxffgrnZzSwqewLS6Pq9TDtKZ6WmucmhfmzSB107E/X6ivGLUVp45KTghCy/SvTJaV9ZdE7eoIQ+QKfM51OPFU4Uzte1js13XVxU8pOW3QgEkzNB4Hqw7J4hqBxQDSUFkVUtwS6Rk6YcHtyiIjoo4t4eQ7kXEL9YQtZn8fsTmGpOIb55afazU3QWTXjldxyuVAfvGyOSfZkTM6GUEuOGtk3i5aEupD8VYDSuaNPUMpGH4xQndhy1Nu/dEjwpVSWWUQqi3Pg/RM+TX606zfYw9gJPsC+hHhi/SKk/OAJoRF9yL2r4CMgzOF8bUjwkgRJsfWMunoCihmJJihVxczFCLsmwK8RpHKUFxzgDrIUOjAncS4OYnmAngBwp6dRG3ZKoWAc1L/yqrc47Mc5MRl+aVyKm23AKdcxDHKsTHlXuto9GfkAWZzYfwFQObl4/kKb1ppbVon8NWXfaMnMrZjQR3iYPLSXXcDY2bBB
 pEyu6/T+
 J6Zi0nwQkZu3qZ0O7LI1pJnxekVOe2vRtifcL9hYNPyZz64CsUpgbytl9UtTRvkyXN1Cvh7wN0NAljlpiPIJs5PKG7igazdfIO9ngTmssG0LkrEpU3WfELmMatji0znXCa33q5Uv/F1IQbXAUeO4S/7VaOJUZ3/I8FM2xgOhNhiHcGbslr64nmpQp6PQOMSqBSbNQUEznNjQcOrRvTevmZXT70pqjddYF4iXPNXis7SrgfckqWVzkkFsxcNLuXfC0Y5rnQdaQbmiaFwY+lO5rOTV7qJcGOB87CqIjwQlveZF19Y7+fC/Q3Hu4oVhvvBQSq1lyJKzlD8idzTVsJS7sPyv/1jbUgC/uM2zT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:48:38PM +0100, David Hildenbrand (Arm) wrote:
> 
> > +
> > +void write_file(const char *path, const char *buf, size_t buflen)
> > +{
> > +	int fd;
> > +	ssize_t numwritten;
> > +
> > +	fd = open(path, O_WRONLY);
> > +	if (fd == -1)
> > +		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> > +
> > +	numwritten = write(fd, buf, buflen - 1);
> > +	close(fd);
> > +	if (numwritten < 1)
> > +		ksft_exit_fail_msg("Write failed\n");
> I guess we could indeed test here easily for
> 
> 	if (numwritten != buflen - 1)

Looks like you are right. AI provided other questions on this helper,
maybe I can append a patch in the series to do such robust improvement.

> 
> But then, we don't really expect only partial writes to succeed here.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David
> 


