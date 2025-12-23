Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9ABBE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 03:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCB16B0088; Mon, 22 Dec 2025 22:04:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169DC6B0089; Mon, 22 Dec 2025 22:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0771B6B008A; Mon, 22 Dec 2025 22:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E71C16B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:04:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 753CF59033
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:04:55 +0000 (UTC)
X-FDA: 84249243750.19.758B07D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79C262000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:04:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NBxKrYLe;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766459093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLHMRdZp+52WlmJl70YIYmzq63XF1C8+A5V76VrIqbw=;
	b=Ri1ZEYdTL5hGORuIEVhW0pQfOgkUR4WTq2xd2fEg02Z0q0UBsFoYro9FTnH52aLpm+nCZ4
	NHH3pZI0BDFoOvZi7hCkTTrQHwF2QT4KIE7Ktwsw2gPQfiEjbbAaoSRJciJu7KywhaUkTp
	N2d2cp9d8BNFfUR9ikHVcb+oSF7z644=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NBxKrYLe;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766459093; a=rsa-sha256;
	cv=none;
	b=VUhOVvvInvi19Wt2+tGF+racLRu/QfNDtgNAtGe0ObRqBM0B5mkwx3xU5hsySxRBnxbAFm
	qQuB7Qc1dkSlMR/rdMUnxcmwQuf42TIpkaYDpkgdOt0/iQY0WUiE4Qq+kLN3i5YhdZtnV5
	sasJiYJmnxWnaQ3ixnuugKFIwDN0AiY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766459092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nLHMRdZp+52WlmJl70YIYmzq63XF1C8+A5V76VrIqbw=;
	b=NBxKrYLe6iEJPb3eIeFwR6WChcACVMgpEINcjJe/1/stIqBx+kFjXaZ/JNlZiR446D96Xe
	wwmvDVijHk1PNPPHLo8ORLt0jTU8z47Q7JZpitSyeOr7ftOC3u/XMC4upICj5IR90Ftdil
	9Wfoy/mu9nJB9rcHOILMtp/6s51Hrlc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-FO9ON-jNNkaN51tbHpAx8g-1; Mon,
 22 Dec 2025 22:04:48 -0500
X-MC-Unique: FO9ON-jNNkaN51tbHpAx8g-1
X-Mimecast-MFC-AGG-ID: FO9ON-jNNkaN51tbHpAx8g_1766459086
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82163180060D;
	Tue, 23 Dec 2025 03:04:46 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.13])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FEAE19560A7;
	Tue, 23 Dec 2025 03:04:38 +0000 (UTC)
Date: Tue, 23 Dec 2025 11:04:34 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luiz Capitulino <luizcap@redhat.com>, david@kernel.org,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 4/5] selftests/mm: va_high_addr_switch return fail
 when either test failed
Message-ID: <aUoGwqSnRbPWD0aR@gmail.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
 <20251221040025.3159990-3-chuhu@redhat.com>
 <20251221040025.3159990-4-chuhu@redhat.com>
 <469acbcf-22f2-4774-8cf3-7f68c7095c0a@redhat.com>
 <aUoCepcpRjuMKoNW@gmail.com>
 <20251222185618.e5c3e0303cdc5f34c45c9a29@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222185618.e5c3e0303cdc5f34c45c9a29@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79C262000C
X-Stat-Signature: psiapksnuzio8grgun57qyf55kaojopx
X-HE-Tag: 1766459093-302203
X-HE-Meta: U2FsdGVkX1/aOhirZs6Jt2NdIE6GPm3T8adGuT3W3fcoYNVeiIGiYgbKJvz8ZO4Uhl3nIpMQB72W941OQH6uLC6F1LCOR+n/4DnxXJDyqXMwzbs7RgTH5vrupBwacyyKZ5Zb/wpj99mEcHwSlCKgiWl7Vdlj+qgmm3gToGhEmbftFBOPAudiKIVI2/ENw1uLiordGMoCmOfxFKeTrcABnxmVMeidRqQQbfHukrtGWvBu4XjZ5968MdiY3Armp90Q93O4HuqemFDuyX+kXzBSi91/6uxSpkwvFE62UgaQ2UmHp4k65XdewXmO1UmEC9/yL4cJBnZ1ZsP6d2iS/GBXDWEP0G601uzKIEqD4z67Oh+azCrLTRaSDUU5oLs/kQyeknsW4uTjKUDWRRT6tNL7SlgUG9i9vpxjiip6XgjvXbypJFlKVjpL0WQLGKY5mGEDnAa9Ar1H/8LJ497Es0EuqugoG6xXZBmgOLqqNGS7tdH2y6RT1VIen/jDUARkExQLFrH1ExOK5OlbOYVgfF4fnMna24xGjkKhEvWo5sPNZuU64ibrlOsRjo+zZXL6CfXPE95dSRUnEK+liZgiYrKSmlPm8Ymj9g8N41s/yf5EP8HsywpnrSbjvx4HiOt6hcfNYWPhdojbMVU/iEHbm68pZO+rqBJwlUE5CjHKI7I+PVgMHpG5GV2yKXJ0k40CsCMNzZ+EL1jrXu7R8PaKbksnpe4dnpyB9D5vZdtwOBTZRfEQGd/DHi1PSb8PSGD1duXeVN9ThtJU2V4cJHz8NfXiMPLkyjlIu3EbV9dpsVcYUmdja5rHwQ01dG8TlusrlHXdyWyEMJ8tMOzOmgh+tnHcPN6UxJzNvGKKsE0vc+CKONWCcWB9C/9cn19U4Nu8ZCwgEEZ80EdwHLIWtmdcPuqbV9hpPMv1q6wXgOaKtBgsV/nXdEJVdwofBlOhp/J8z6Xpd2RzbjwvuXMv334ulgP
 H36/VhGd
 URFzRzIi7RJfDGqqCNZqSr5sL3lTbpOLLPA3XwwcBbkJ/uu2VMBBycMhzWzMov13PwwS75Vs+xYVVFHjnQvzL2/DwbstRbkUAX3+ueDnKRML+a4ew190j3bj+1MXl/AsfloGmqNo+W4pI3ItAolOor+mrdYDn7p3n0Seu0CcusSNtRWcg2GmHbQjLfJzCnZnh+8jjIMUUI4gvnk8+sfKw42+ao6lbWvOiVrXt0SIiW5i7BEWiIL8aUa7PqQwlivOfd0ioUajF+knfXwDHgR/9rmte9tG/H1VKbOsr8JiXJpWFmnA5601DlXL+5KakeSohmZKmTVKvCyBFXYnZOltII3CzUCBYtJLKXh/U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 06:56:18PM -0800, Andrew Morton wrote:
> On Tue, 23 Dec 2025 10:46:18 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > > >   int main(int argc, char **argv)
> > > >   {
> > > > -	int ret;
> > > > +	int ret, hugetlb_ret = KSFT_PASS;
> > > >   	if (!supported_arch())
> > > >   		return KSFT_SKIP;
> > > > @@ -331,6 +331,10 @@ int main(int argc, char **argv)
> > > >   	ret = run_test(testcases, sz_testcases);
> > > >   	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> > > > -		ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> > > 
> > > Maybe you could just have used:
> > > 
> > > 		ret |= run_test(hugetlb_testcases, sz_hugetlb_testcases);
> > 
> > Good point. I thought the result code is not encoded by bit, but for
> > KSFT_PASS and KSFT_FAIL, and KSFT_SKIP, they are per bit.
> > 
> >    85 #define KSFT_PASS  0
> >    86 #define KSFT_FAIL  1
> >    87 #define KSFT_XFAIL 2
> >    88 #define KSFT_XPASS 3
> >    89 #define KSFT_SKIP  4
> > 
> > @Andrew, do you think I need to send a v3 for using the simpified way?
> > if so, send the whole series or the single patch?
> 
> Leave it as it is?  This thing isn't a bitfield, so using |= happens to
> work thanks to good luck.

It works for me. Thanks.

> 


