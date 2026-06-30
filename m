Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB628C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CFB6B010A; Tue, 30 Jun 2026 05:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDFD6B010B; Tue, 30 Jun 2026 05:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615E96B010C; Tue, 30 Jun 2026 05:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3850C6B010A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:30:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4200167B6B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:30:35 +0000 (UTC)
X-FDA: 84936058830.17.0742048
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id C0E3E8000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:30:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KHnKuuA2;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782811833;
	b=nszPR0LMRTc69ivJKRQPOkWkTybUUZg+tdxSt8K7L+DWG5C2msd0a4DeKPLSOcMnkNt+HF
	hK/DHdwYWQ8j4xGzKvEkHmDEON5F3JuN0KqPlBZOG5jzy6fsa3qDIi2lzRsQRkWvFCE4HN
	Kh1LMEzMKGDC0Z0b9tn3/IrAQ+cmycQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782811833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nbrEw8HxPIVYOk3lCiNdzXrvv3ZUctNh/Crii5aUdc=;
	b=WtfFLhaYW27ZLY1qcL2ygxOPdozZ72yTVTwebHTVVTa85PcNSroV+bJYL1h9ZQg0j5naNC
	a9q7ru7N1RYXYAGwj9uQf0WfheMAG2OD4b/esfNAkG3fymWsEoaufPJuWqacL+Os/Aju08
	wB5413nYVpBuywylrbXWimBQCyuVlZY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KHnKuuA2;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782811828; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8nbrEw8HxPIVYOk3lCiNdzXrvv3ZUctNh/Crii5aUdc=;
	b=KHnKuuA2xz1wd3FwzcThUBUkZfzuKXYK8M0dVp3IhEbpfuotZdJapv1BAFGnGF9s5GszmO4YDiab0Oo0wDlwRa5ni8U+RLXU6w7BQ4bcNEVPPju7VK7cpBz9e44XZS3H+Sy66uxSZSZTziGWz6r9Agjxbg0QMpeZsKWGvyXYDJY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X6-zr.q_1782811825;
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6-zr.q_1782811825 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Jun 2026 17:30:26 +0800
Message-ID: <1d27c781-0adc-474d-9c75-899e63bf7490@linux.alibaba.com>
Date: Tue, 30 Jun 2026 17:30:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shmem: Fix data-race in shmem_fault
To: yahia <yahia.a.abdrabou@gmail.com>, hughd@google.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
References: <8b6aecca-c4fe-441b-b0f9-fff10f7b43af@linux.alibaba.com>
 <20260629040345.13138-1-yahia.a.abdrabou@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260629040345.13138-1-yahia.a.abdrabou@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dbp33hiegdw9u1jo3nw7m9nen7frxpxi
X-Rspamd-Queue-Id: C0E3E8000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782811831-164616
X-HE-Meta: U2FsdGVkX18wrN4E5ug9BsEijnt0bwb6KL43YZouLP0fZaCoMuPVfeIomOCAd9eACsCNHuLAiDgxKCfeCH1SKFaiSK2TMOv23gNfw4i4Yi1z6IM680pSrYldjEVMyfCZjKOgNFKcu+3JWot0qInT3rjRnbJ9To29S3wJ00ewT4qPXV02H6YBVJqWpcdRG/4b67WDk13DcVU5ysC8jQFJRleSOfH3AA4XdvTjXZT7oEhS6Ef5mCfXp2HhNp9e29h3/0d9Vdm9TcpzLdlIOsUlfkn/LXCgFPs+M0GjhVziEViSvUoWnlv82eV5+HD7eFkeeWkp/JQV5HLdPqBPWIP96tTpwRm2eeuQD2onBo18cdyq9+AkK0AQvCG1p7wWfYpmj6OEEMq1piX2O+pgLE+cP0okMF2soRHnRTK7GeijSjkS9T6lct21WaXcvyDuGNFJoJ/pDmBfFvGAlpwEm462BgBYFB+gQ2A05gBSgptUlqKG+TMYoH91wis+OadwfYZXSbfc6RtIoklq/yURss3PKnCp1W/VffVlQS84UlNQ+s9ShSPXB92mdWzKLGEkXujrNgpgjJi0oKdphl3Mhio7+aMF7Mf20iK1QJygejyvYt7C4vke0Ua/fLDHOHEP32DwsB+595mLqiau5nOi9nkNaH7hxFA7Lzyh/zo0yN5/IcRSEbyndtkk4GtfVa9n5PJoFUEEB93gRLBHM8NMIQsfZf4AImN3+OWhcNqEEIeI7rgrd5U9C6NV9JHqAX2OPAoHgxf+dAsI1VGyFbRWOdCton/BATsAicmMadlG6MoZwItsp1dmG53ATW/9ZIF6oNmQl+M6MS74pt+ofdYTEmKcIg6YlADloOd9TWMDxq0r8LdwjonCM5EfCZoll5ktuxkR8V/WFkRMqV9rGL+l+2jQxlUwxgealf0pQNqsamLlNFRg91K1wsdGAJYabFh1uypLEFluq6Dl2YOpltHZQ8v
 rCynDM1x
 QftfLCbAs+t2HzlnhbZaqyjfvXmcRCBQv/2hxaxQzf2pcqK/w8diEjFQxpPX+yB3ooZq+R14it6SAx7FUmHSnL6PG5lFj20GSPbQaTQ2k+oraVBltfVvOe/JDAc1AnyI3tiC6KlVYQiGXxBY374ne9Mn/9+KzLuUSXj0F3XSc96zXd3CPvF5RsAq9b4wjzKNvnme7Oh5RnNK6Mz7zrFieuX4sHRJ6jzILHPEfXNm0c4f8LJAnVRcnAYjfE9jPuZLE4tPIc763vuOpdZtHzXa81da0dA8y0OV7S2/Ocs9pArInXhqb7bQQXHf09IGe6mr+7JuNCmeLnGms/v+W09ft+WTDMdv/HHLeQcqKS7GcVYSen8PImvdsWa79/CyzOHeQZeS4gy7yKoFIicPuTJk5sxwn7cl/ueDh798r3aJ1Bkz94s5t1foPgsU21W71cr8uYvXMq76yRPuFfB1JgVgyB1tH3zGMTg/a8Z3iSxUXlcxVv/ssP2U4DBF8M7VZ43n0pkZBt9ZroHKwC+XftByBtDNEwQbW6MusDnjDkYY1mtldFFOl7bHcgRCsQyXZbQ94GxE+A4L0/fd1BWJnHX5kjgo56xDZMlggTQ4K7H2d2nj7uP9kB2RraB5jzg9h177UXxAl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/29/26 12:03 PM, yahia wrote:
> From: yahia ahmed <yahia.a.abdrabou@gmail.com>
> 
> shmem_fault and shmem_writeout access inode->i_private
> without holding a lock, while shmem_fallocate is modifying
> it while holding a lock, thus a data-race is created.
> 
> Fix this by using READ_ONCE and WRITE_ONCE, which provides
> an atomic, lockless read of inode->i_private which prevents
> compiler optimizations such as caching in registers and add
> writing to inode->i_private with WRITE_ONCE to prevent the
> compiler from writing in registers.
> 
> Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
> Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
> ---
> v3:
> - Fix lockless read in shmem_writeout
> - Apply WRITE_ONCE and READ_ONCE across all
>    locked instances of inode->i_private
> v2:
> - Add WRITE_ONCE to shmem_fallocate()
> ---
>   mm/shmem.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..1c39e9dfc524 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1657,10 +1657,10 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   	 * reactivate the folio, and let shmem_fallocate() quit when too many.
>   	 */
>   	if (!folio_test_uptodate(folio)) {
> -		if (inode->i_private) {
> +		if (READ_ONCE(inode->i_private)) {
>   			struct shmem_falloc *shmem_falloc;
>   			spin_lock(&inode->i_lock);
> -			shmem_falloc = inode->i_private;
> +			shmem_falloc = READ_ONCE(inode->i_private);

The locked read cannot race with the write side, so READ_ONCE() is 
unnecessary here.

>   			if (shmem_falloc &&
>   			    !shmem_falloc->waitq &&
>   			    index >= shmem_falloc->start &&
> @@ -2647,7 +2647,7 @@ static vm_fault_t shmem_falloc_wait(struct vm_fault *vmf, struct inode *inode)
>   	vm_fault_t ret = 0;
>   
>   	spin_lock(&inode->i_lock);
> -	shmem_falloc = inode->i_private;
> +	shmem_falloc = READ_ONCE(inode->i_private);

Ditto.

