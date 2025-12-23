Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A8FE6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E5C6B0088; Mon, 22 Dec 2025 21:46:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F60B6B0089; Mon, 22 Dec 2025 21:46:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621EE6B008A; Mon, 22 Dec 2025 21:46:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F82F6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:46:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EECFD1A0491
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:46:41 +0000 (UTC)
X-FDA: 84249197802.14.75623DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01D08A0002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:46:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TIS5mVkO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766458000; a=rsa-sha256;
	cv=none;
	b=5GOwrV4zCkBDp30CA0Nk+XSUwi+gA2VrYPOLeEfvF85seVxQ5b4vV594aal3WmaUfya/zd
	474j7SU6aI5Uy2CygGCnxAYYqMQ8o7w1EMX3DocIyPCNLPdwf4Yt6XPrZc9MQMLsG8IvxX
	Us5qaOmv5C4HsNO1ja4+Qwl0CDEUq1M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TIS5mVkO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766458000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2Rlf4OXs36AH80vjIKvAiM7VqatDlbcrhnjVYLo8N0=;
	b=FPFQzx+k23duCycmgPnqtqYw1Ri8k/bGxeu1o99uhDux2jjV4q7EVaGvlsj+d+ojc8hCft
	wf80CZ1VPR2ryT6qa10gVgDsGFz6Dp0pn2ftZuUGzCM3vfvKYIV+0pMqr4jz0Mbq0z53q4
	5UC2vigMWAGQtHE3VfjUhlrlOMdKCXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766457999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P2Rlf4OXs36AH80vjIKvAiM7VqatDlbcrhnjVYLo8N0=;
	b=TIS5mVkO/sJ8d6DD5IZIR9MoioBwl3mqqNMpZll0/PRzCxwcifgXyhdFqmUDXCkbKZjKuf
	CwRbNHb/wSpBdnrs0Up6GkA6LeZ53jqambcJIAInTs3kb8SnEwOrPe3qkP8ekuklWSu/Jc
	2v+oNRwgKV/8Mj3RlMzqYRx1w6lV6j0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-ca8xmKuzNReQJJjUDgZbCQ-1; Mon,
 22 Dec 2025 21:46:33 -0500
X-MC-Unique: ca8xmKuzNReQJJjUDgZbCQ-1
X-Mimecast-MFC-AGG-ID: ca8xmKuzNReQJJjUDgZbCQ_1766457992
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 112291800365;
	Tue, 23 Dec 2025 02:46:32 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.13])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3ECE30001A8;
	Tue, 23 Dec 2025 02:46:23 +0000 (UTC)
Date: Tue, 23 Dec 2025 10:46:18 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Luiz Capitulino <luizcap@redhat.com>, akpm@linux-foundation.org
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 4/5] selftests/mm: va_high_addr_switch return fail
 when either test failed
Message-ID: <aUoCepcpRjuMKoNW@gmail.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
 <20251221040025.3159990-3-chuhu@redhat.com>
 <20251221040025.3159990-4-chuhu@redhat.com>
 <469acbcf-22f2-4774-8cf3-7f68c7095c0a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469acbcf-22f2-4774-8cf3-7f68c7095c0a@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 01D08A0002
X-Stat-Signature: 4fe3dj65bbr85kjjp5k5xz1okgwut4d9
X-HE-Tag: 1766457999-226963
X-HE-Meta: U2FsdGVkX19wL8t7FpR9dokWViu73ajUEjdxQZY3KMjQ7UhP++tjFqjMZO9Pz0tqUplB32w1Auh3m/kRzW6zaXCk34ignlwlzBAx5mlpxrbKr2Qzmhu9s0xZhe9eSTzjQQC2brcJ1bFMPj8AEPYwYKKBoO39LLxCdknQiC8+OLkoa4jUJR6uf/MSuSMLuZV3qYkVwJm8enSzh5vYWQZsFze4TmS/v1QDnHf9hwNlPvwb2DDOEq3ytLV+67hLHHWRMTg3Z7wOKUWVI1dNMUw98asQZkPMHJ0HQYdqutyRTw7BEQbfqVZNoapiFeMMJDsSOxBahb7SpuylfVDbgPNHe4MVbhzZ7kBo9kXbRTO6rQWiIALiE7ACEXr4uTlhIHIDvf0hVPTlxtbjKAY+2G3XumYj43eqn2q/nltbL0fcZW/blTzVD6BgF9KKDtBQtaRw5xzMGmkQJzZ8GR1x/sfimMQsaMrz64KUMzeJRsgsEi9qjn70zH/xr5nzYvtMM81ugsJEVuoCCLxsnns12YC7wWLd2pqhlsqZen3pA6MohnokuD8QAYmSAcNg9U45kJF5u9d8+yqNy1Dj2x5zIMHeofnNHuTNnLXDnPrWH7yzbrx6L4ld9K0OI/qG2qrgoNPreu4Of3gQR0371xSObTOeECCj+bUW9YBvf8bcmUbx4RuGiMM3tQWGZWiXwQvXYA3/PXtDBwghREDxBqEp2OKPr+g6aF5oow0iYF7VgW5TSFZEDoitEcNJnGY/y85jpRN2mzooRzM9V+0GAQhPMR2hzOrtjUMjKT2e8EecOJeXQuy7ZXBML9JoykH1XmPolmSrDWXdVetYFOoXxoDiUhuq4IO3YGNFVc2LY6f6u/6wSntTfQvlvN2a3hRySt10y9jZDi5iWqRcY54B8A/oJs0RL+oGKoZ1sOkXEBsKozuiR0stB6XtqYstXwxCQosvh1hxVVMqs7boQrBbZNac2OI
 L3MC75uc
 AhQxUyq9JSSLk7zE7nLZd8UfoPCpXKrkcAgkOitSnIv/hpcyPAFZ5tdmT6QaPHMx2zPNuMbWpfOSeSE88V+XDGSle9TtX1xAW0F53Tq9C2h1MiuSINWCLD9nrx48hh6u7HeqYPqSrer5lhQR7ZVVneFA0LwaOKJaG6UcUQBvnES6fgljeMC2hhTdbFXurtyf/YLZw0PAaXg162LdHouIj6BM0Iy0H2rSPepODuG/domKzag2qMDEuA1/iD7KN2HCRuh7SQHoJHalY5be7QIXJWlEA6PVSBIDAmZqlB6sPenTWoaq6kmjqOt4aqOCNb/m7KIeT0HrF/cUuhy8SiqJZSOXY/KAZVR77F5QC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 02:36:18PM -0500, Luiz Capitulino wrote:
> On 2025-12-20 23:00, Chunyu Hu wrote:
> > When the first test failed, and the hugetlb test passed, the result would
> > be pass, but we expect a fail. Fix this issue by returning fail if either
> > is not KSFT_PASS.
> > 
> > CC: Luiz Capitulino <luizcap@redhat.com>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >   tools/testing/selftests/mm/va_high_addr_switch.c | 10 +++++++---
> >   1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> > index 02f290a69132..51401e081b20 100644
> > --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> > +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> > @@ -322,7 +322,7 @@ static int supported_arch(void)
> >   int main(int argc, char **argv)
> >   {
> > -	int ret;
> > +	int ret, hugetlb_ret = KSFT_PASS;
> >   	if (!supported_arch())
> >   		return KSFT_SKIP;
> > @@ -331,6 +331,10 @@ int main(int argc, char **argv)
> >   	ret = run_test(testcases, sz_testcases);
> >   	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> > -		ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> 
> Maybe you could just have used:
> 
> 		ret |= run_test(hugetlb_testcases, sz_hugetlb_testcases);

Good point. I thought the result code is not encoded by bit, but for
KSFT_PASS and KSFT_FAIL, and KSFT_SKIP, they are per bit.

   85 #define KSFT_PASS  0
   86 #define KSFT_FAIL  1
   87 #define KSFT_XFAIL 2
   88 #define KSFT_XPASS 3
   89 #define KSFT_SKIP  4

@Andrew, do you think I need to send a v3 for using the simpified way?
if so, send the whole series or the single patch?

> 
> But anyways, as this is just testing code:
> 
> Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
> 
> > -	return ret;
> > +		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> > +
> > +	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
> > +		return KSFT_PASS;
> > +	else
> > +		return KSFT_FAIL;
> >   }
> 


