Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32EFC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 21:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB9E6B008A; Tue,  8 Sep 2026 17:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC656B008C; Tue,  8 Sep 2026 17:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B2F6B0092; Tue,  8 Sep 2026 17:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 203DE6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:02:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C5A51207C0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:02:25 +0000 (UTC)
X-FDA: 85191818250.12.EB9D35F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A46C420008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:02:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCRj10zz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788901343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUj2tGJ84SLrIUDajcfhUjeh5g/d0LaSfpAMYFutJ7Y=;
	b=H0v/PCQsbUXoZL5z7qxbJ5O6T48tfJklfTK+tMojg0sz5f/FsXLA0f3KRVe6GFj7C39nzv
	LcIov6UcYWsGghERewmQa5EqkiIXfSkbY7U2qjEkzijldHy940zsDkOePXbsCNCxHSrtzX
	zE3JDf+2+Mg/khWeXHoViFhaPSD2K4o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788901343;
	b=kaOHCWbJHA+5d96CkOvNAJI7xvzXaEMVlJ9ubzq++eKcs85jAjuOWyOupdcyka3WI05F6w
	0Rc39P4DonzfzYNeiyK8gUbQRerNkFGilVNBHJvfXkRPRJclYLuHeC7GWypS8C0wNUsZaB
	K0wG7+6sJhkYi8zRSLf6NgJdzhssqCM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCRj10zz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CBEC601DE;
	Tue,  8 Sep 2026 21:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D131F00A3A;
	Tue,  8 Sep 2026 21:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901342;
	bh=sUj2tGJ84SLrIUDajcfhUjeh5g/d0LaSfpAMYFutJ7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JCRj10zzlHMwLx+4DZ1w6ePXNa1xoU0MZyluycdxUvJl3W2DLiysbVUOUBYcqcsUg
	 q2k8WBeuDnjrNiEVfogw+ntY0dBsBgn4kk8D06WyqJtmfY6TdUNPiTIQebOp7gZVnx
	 /aRFjRCRPX4/qaaDDphcsL9rWNd8TqG05pQHmHDkMqy/9mRB66sZ+H/7ULGk5Y8f+2
	 KKhAQzbMwFWtkPd5icTlTpFIYuQpHvywonf/F6OKBwXvvY5e6CODNUx+T5PvTB42Ip
	 riAXNaMIEztZzyZija0aSXLxbgdCyZISc5a4ULWw62fQpBr8TSONRvN1MlHfrxHW8+
	 r6Nz2e+0xtCug==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.ams.internal (Postfix) with ESMTP id F0114198003A;
	Tue,  8 Sep 2026 17:02:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 08 Sep 2026 17:02:20 -0400
X-ME-Sender: <xms:13egaiv3I5NU7VkxDzDwWakKBx8vLWSGAgFoGO2JwU1lWM-KeeqChA>
    <xme:13egaoLrTAGAf8PKDwojN6-fnAt2cd4EKu1ADshk71glMBbS5cFtGKptEky8Wf1mK
    DcE4DRcHGIKZ0-s35gl6A84yMKZ_cBAZlaKukZDnr17HgrXngKHGiyT>
X-ME-Received: <xmr:13egao15JrCthvAwd8a67FoiaL1RBjeWvS1WTY6pLhSSX7ZYGuMumx-nnCk>
X-ME-Proxy-Cause: dmFkZTEAILA6vc5JwE1AywUZhHj3jrCZoHnZLeOWd69ORmx0fD70m1rj/vEtHXnDNbZ/3S
    JbZrhvU5i2gCAEseWg8ahCUqEo46O8afIzjj0LeuDxoGzqZkV4cyrGYUvzgqoZJBMTbuN3
    jWKEzH/ZQxzy4VmBoZ/TyPXkyEjAB/tHZ0tKcccELp4/GxOE707NkBOG3g7PkbB1CzqEvp
    0KtWO2dtBG8BGkW68TQrYp3sdyh7ETyZWTuT1ajiI1J4Dru/d8hD6yTvO4U44jWIhYkACx
    rvPqpCBmfzl7xqOEdFrgQJTocBrtcyT7b7+4p5MkFHwVAlUgpoFxlnvSuXq+EVi/E6wyA4
    jILJ2dkKz6ujRedUs17ko3DHmINS6jdEsRiP9kfTzh/RpKaTP7B5ZkQbqFKOd7D/vNQLbA
    bK89aIgAq5FvDxLP48Lr78jJrP6NuZsN1fI4VZw2iDkD4ZnhKlbOkr7Afi5PePALdNioVI
    LhnrDLQw8dZE2Idm2XTLoFEvPVu2uts0bwZvGqaSs/d+59+2ZmV3BM/ozt0gX0AzUHmmk5
    v8xJQ8yq8yZghiLCvaLLa8E/MLHjrrHicKDlNCB/+dK59W2PDOeVCdVjazxT+ELm90imLW
    SMgwKeJSPEkDdeizukYNUVo7WsuiX1HboFGYpxHaZAh8j6q4jV17QrpNE83g
X-ME-Proxy: <xmx:13egatNAY0gyHF6R4MNJ2-Ya2RdYgFjVX7fJm3Fcf1lra-j6koLYgw>
    <xmx:13egal61Vs39srGUNYlctXsK5TryErbfKl0XKBwTa_8pRfE2UQGiOg>
    <xmx:13egal-4yhKJnXzCc2CFEPcDpLvaijicsF3Bg-Gacyubo9BYdlPyFg>
    <xmx:13egaqj-pW7Huvu53CmtDnjJDCbTP068Poqs9cr4bS8Axsg-oopNlQ>
    <xmx:13egahmeoFhUN6TXVAB1XzkQVfQz7gqe46pSSN2oPS23zCImg4QRCcmX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 17:02:14 -0400 (EDT)
Date: Tue, 8 Sep 2026 22:02:13 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 13/19] selftests/mm: cover a shared-source collapse
 write race
Message-ID: <aqB2ckEupUKnoJt_@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-14-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908125105.1510704-14-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A46C420008
X-Stat-Signature: neieggwqoc3k4hmnmr163xojw9bh5bap
X-HE-Tag: 1788901343-33980
X-HE-Meta: U2FsdGVkX19se0dWgL1W6rsqnnSePUEib4zGJwx3X0ExXID/n/Gxax4lyMyqKSgjP5WWJu0wh0d8HcqdOFXA+enIu8htWgTe/1Blzb/QvYWJiB9e1Qi4HC526AgFSC1gQkand+cKiVT95qh4dG9rTDsmvFGM3Mjl4zFMvvdj4BJe1N7TsXcn0C3oBkn5drQT1+van0sasm0zkHbxqJ5lC8ktc7JNIUqCje8wILpROjKkWAJFpyL3gpbL2NLgxpFFkhR3S7zfuO+BVm5gQjpRlp2sRcxTBARYbmre5nGkjpyinqweXaBvR9sygwZuvkojbLh4U/kwmw6Z/OwjQMHvhZ6Z26C1dtGqNkkKXlhZgnGmL5Z1nNzDE3CzSmsOYhj+UBg0l+QRBRnSd4OxQ8ACy7zPpLRaUYJHxFkF68Z0wMH25cZP7Ly0CG3ztWS9hMnktHo3o/R2Wt5gMtBhIwyew0IjKTUnVJvc/0lW2K3jiY8nxeQ5DXLZpCavgh+mOAxS6yNlTgk8XtXooKldfU1eJPj6iLyxxyZlVz+i3/BiwCHTurybvsbvwJwBfo5Q8sx3hFbx4oJfMQbZrMDceQUDlVkxa5WprSDUdMHd8prF51zvZNEbJqx425C1QUNB0Qy26RvihLTri5+jE3KNytdkZvOWvfJejYl3xfEfM812cJpxzLftUcxaAYAYhWlxogoVItGv9jxp7sJC/6TAbl9wDWgNOY9XmqsKUrTbqQoxkLDCyU4OC3rpTZCAtrT3SezU5TmmFMJWWRV+D2ZHSPy1MvxR8AIwv7nMNgnM4GDaqGEOWIBKCYZ8ASp6NlcOoOBNGaJQtcpybAn9+z4/VvWKVJX8l8KG5UcfniqSk6Jrm/oYEQjVD49c2HcO6itrQsmUKSRiQijBgGCAEKz0s1lAwOyh+F+iC0WUd1pQZZF+3c4xIVVqBJsNsITRPNiWckQVMOtkosjvRyMD2EA1Gem
 IUvSfiM9
 v0L+QI6MiDSjk0TpYq2Uab+bPUQqjDGhQ4zRt0eYvO8oiUJBI6CKyzB3tn+y14X/JbowkpzwsIum8GDkbZW0r+ZbCrykdCZj9UWSqCA5EFRm9jOO9RdaWyT2Mx5hWfRUOXbVNzzZYWKif7P8sarhNm2k7RcagnvVCmiKuPjtWi0WqCG0EHr23mQugKM+0MfvGK11BTZyJ1XaV5PX3+5Lw0Ba6ms4BTnT3riGduCHA522XmTN1toOJLapoupsAlhagxUmOHWGL45Bwl5emG+kIiQkBZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 01:50:59PM +0100, Kiryl Shutsemau wrote:
> +	close(sync[1]);
> +	if (read(sync[0], &go, 1) != 1)
> +		ksft_exit_fail_msg("child never reached the collapse\n");
> +
> +	/*
> +	 * Unshare one page at a time: a burst would break CoW on the whole
> +	 * range before the collapse starts, leaving nothing shared to collapse.
> +	 */
> +	i = 0;
> +	for (;;) {
> +		if (i < n)
> +			ip[i * stride] = i + 0xbeef0000;
> +		i++;
> +		usleep(10 * 1000);
> +		if (waitpid(child, &wstatus, WNOHANG))
> +			break;
> +	}

Sashiko flagged two issues here:

 - sync[0] never closed. It is fd leak;

 - wstatus is garbage if waitpid() fails, returning -1;

Here's a fixup:

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 335f946eca61..c0a07d75a306 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1228,6 +1228,7 @@ static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *o
 	close(sync[1]);
 	if (read(sync[0], &go, 1) != 1)
 		ksft_exit_fail_msg("child never reached the collapse\n");
+	close(sync[0]);
 
 	/*
 	* Unshare one page at a time: a burst would break CoW on the whole
@@ -1235,12 +1236,17 @@ static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *o
 	*/
 	i = 0;
 	for (;;) {
+		pid_t ret;
+
 		if (i < n)
 			ip[i * stride] = i + 0xbeef0000;
 		i++;
 		usleep(10 * 1000);
-		if (waitpid(child, &wstatus, WNOHANG))
+		ret = waitpid(child, &wstatus, WNOHANG);
+		if (ret == child)
 			break;
+		if (ret < 0)
+			ksft_exit_fail_perror("waitpid()");
 	}
 
 	/* Finish whatever the paced sweep did not reach */
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

