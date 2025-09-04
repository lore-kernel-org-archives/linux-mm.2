Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E617CCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AC58E000D; Thu,  4 Sep 2025 10:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432C48E0002; Thu,  4 Sep 2025 10:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348918E000D; Thu,  4 Sep 2025 10:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 245DC8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:52:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E494E1DC9F8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:52:44 +0000 (UTC)
X-FDA: 83851859448.07.AB75E48
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1F4C61A0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:52:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VP2sT/EA";
	spf=pass (imf19.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756997563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BazxnC+Wcptnkdd+tPophW9XIDvM64THaSvkRAFx9Mg=;
	b=LuxngrKCRCwkvl0FE1d1Rlydj3YFxv+P/GBaiJix7gMvHSo15LAPL47u3/XWOq1SdKD9T7
	h2KGNW8RJiGCpiIdor3zBaAE7qL8hOEQ3Lgz1quAO+GnzUJEF4Qht/lLMlHF1LOJSRDaEg
	ozFav2JfXub+qicsBfgRU+3/A4/FRRw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VP2sT/EA";
	spf=pass (imf19.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756997563; a=rsa-sha256;
	cv=none;
	b=LmPueOt8/WMSZpaQ9/MHK4thaBfZWW2chPS/+x4KnQNfyjc9L0WExb6Md7XQ/gVZNpVvKz
	0UxhYTtzoPGp5yH9LVMwZmztL29uhy4kfp9Fgbo/OxxQ1tvMZmv5uHtD7NE9mtKF1/2XM+
	Hu3fEYnJYm4kIuBS1KpY6JvqFLRjMiI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756997562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BazxnC+Wcptnkdd+tPophW9XIDvM64THaSvkRAFx9Mg=;
	b=VP2sT/EAUXPlLqopVQROh9M94Ion1zcudzMoJnrel8N+jIfL1KCXIxEfFDFMPx021vVhKV
	11a/AjixhxvrzFLjTiaMWRw2bZz6sUwc0yuPsTF9sVn4wFR0erR7nIGlNe82Uzkd0o7Nd+
	2RXp0vxtKXVDNTEbED+VOsrdKfLXulY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-1O0OaGzTPK-kKLpbyr87uA-1; Thu,
 04 Sep 2025 10:52:39 -0400
X-MC-Unique: 1O0OaGzTPK-kKLpbyr87uA-1
X-Mimecast-MFC-AGG-ID: 1O0OaGzTPK-kKLpbyr87uA_1756997556
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 631281800291;
	Thu,  4 Sep 2025 14:52:36 +0000 (UTC)
Received: from gmail.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C81361955F24;
	Thu,  4 Sep 2025 14:52:29 +0000 (UTC)
Date: Thu, 4 Sep 2025 22:52:25 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: [RESEND] Re: [PATCH 1/2] selftests/mm: fix hugepages cleanup too
 early
Message-ID: <aLmnqYrAaa4MrZZA@gmail.com>
References: <20250827075209.2347015-1-chuhu@redhat.com>
 <20250827075209.2347015-2-chuhu@redhat.com>
 <87956f34-e6b0-4d03-b30e-56be4f6b84f1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87956f34-e6b0-4d03-b30e-56be4f6b84f1@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 1F4C61A0002
X-Rspam-User: 
X-Stat-Signature: 4mz5i5wnet15gw4zx9pk9wjf4f8wjcuz
X-Rspamd-Server: rspam09
X-HE-Tag: 1756997562-455235
X-HE-Meta: U2FsdGVkX18x4ZJqC1ev2wu5L9Cpr8DgcIHu0vc6RVgcxPBqNdXay+f+uiaYALF3+/P+Dp7uRHS2OXEghHvQ/8iuJRo+trCAaaItkZVVDctLqRsRsbxzMjRdNRGcRauZJKUkcNoiUD2Vt4Z/wdJbidk3SOoLXnoxqegdCaXlr6B6oS1oXYlHLFqtIUdCDjAtl6xvLRIWGrTvGaIVRtSZLl9xdLS6rtPxoca/kaFbo+3ZA7qNITIdN6NhF/Zh7F2vzRvbbS1gVMWTxoFDZGFOdtD0KKU07193aP8cCEPQmAGoMpkUrxSAzGvHEY0XjAad/gFb2ovGx+LaQs/80aZf9c/FH8NfTV9fH98zaXs9V06cnP1HHVerJCPdBtNix2AU3lPN9ZWMo/sVMksMWq1xz1qplFolciZIuzLNzNJy1XoSPgY9pBmQuhzjhQM6OFKsvELyhfuLem9D1qsqKyDHIMzJkTX2PA1+lgS7ijm0J7yU/NpGO1SSSESWXVt0TTt+h3nHWuBY34GaUtPZ/Ppm8X3pKRA1N5DW45ztd7yBTc+zcSjpTspVAoHhpHrn+9OejROedgms9dL6TOpg/m1KYbEVKBB63FYtbOnxugCP/KEXr0Y7o63a4K/p6ALa65qQxu0znxQKaMVxtGOq/H5rYFKQ/r3FWbU2gHZnuWZM6E5lqbWh7F4wZWiAc5qt/TJtz/a+VJLVGRffnUg1ioPa5dFlJiH2/a9W05lAJvImaYr0sK1o0o+wG5hU8PVmd3D/TiPEFzy6PfV6WEhyPiWuQbZmIH1LgrSiitgXyBti1sTP/sC12Rvq3ESGehD/pKVT2D7ebdDWZGFD880ourAn2HsV83VEww1CWo7Eve6Kjow/NuJQbxoLsLa0QKt1xhqJKfrixWI9qEykgW3BVjIoHuQjXFTiEwmoEV4U/Uez+3V7DDe/UghnYNdiOHpGsU+8LvveCPuljqPJXE9wE63
 ObuTpazM
 h6++9Q2e3U5Qh1fzwDtxFPZ54Ggl6mBb/sIdOZL5M4BUgz/4gOfvTyCbZ1QTmoAEV/ZluqcIaUIrSK+k9O+R5bybxKtelZg0OpZhDVBPXQ6cRaq8oNIzLVcaPwAyE63rmOnCjU4AmUA2cHgo8UddH6wA4BjjND+t7pCdHAlD26XfFQSlpNgVjtmtq7+wSTvmNc2lX1qYUcE479a8/HQq0Axf5RNblp18/GfZb5N3ga685pt7bD+S7N/reZYmB3kexFb0vOERxWBcoqAuj7B6QfFq7NiQcNJnqM32mgW0mNch1lpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 01:41:34PM +0200, David Hildenbrand wrote:
> On 27.08.25 09:52, Chunyu Hu wrote:
> > The nr_hugepgs variable is used to keep the original nr_hugepages at the
> > hugepage setup step at test beginning. After userfaultfd test, a cleaup is
> > executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
> > /proc/sys//vm/nr_hugepages are reset to 'original' value before userfaultfd
> > test starts.
> > 
> > Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
> > nr_hugepgs which is the initial value before the vm_runtests.sh runs, not
> > the value before userfaultfd test starts. 'va_high_addr_swith.sh' tests
> > runs after that will possibly see no hugepages available for test, and got
> > EINVAL when mmap(HUGETLB), making the result invalid.
> > 
> > And before pkey tests, nr_hugepgs is changed to be used as a temp variable
> > to save nr_hugepages before pkey test, and restore it after pkey tests
> > finish. The original nr_hugepages value is not tracked anymore, so no way
> > to restore it after all tests finish.
> > 
> > Add a new variable nr_hugepgs_origin to save the original nr_hugepages, and
> > and restore it to nr_hugepages after all tests finish. And change to use
> > the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after hugepage
> > setup, it's also the value before userfaultfd test starts, and the correct
> > value to be restored after userfaultfd finishes. The va_high_addr_switch.sh
> > broken will be resolved.
> > 
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >   tools/testing/selftests/mm/run_vmtests.sh | 9 +++++++--
> >   1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> > index 471e539d82b8..f1a7ad3ec6a7 100755
> > --- a/tools/testing/selftests/mm/run_vmtests.sh
> > +++ b/tools/testing/selftests/mm/run_vmtests.sh
> > @@ -172,13 +172,13 @@ fi
> >   # set proper nr_hugepages
> >   if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
> > -	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
> > +	nr_hugepgs_origin=$(cat /proc/sys/vm/nr_hugepages)
> 
> I'd call this "orig_nr_hugepgs".

[RESEND to add back the unexpectedly dropped mail list, sorry for that]

Hi David,

Thank you for your review and valuable feedback. I will rename it with
a v2 and resend the two patches. 

> 
> But it's a shame that the naming is then out of sync with nr_size_hugepgs?

nr_size_hugepgs is for uffd-wp-mremap, the test need all sizes hugepages,
it's used to save and restore the nr_hugepagees of all sizes of hugepages,
it's a test case setup, not like nr_hugepgs which is a global/general
setup.
They are not the same kind, maybe they don't need to be aligned.


> 
> 
> >   	needpgs=$((needmem_KB / hpgsize_KB))
> >   	tries=2
> >   	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
> >   		lackpgs=$((needpgs - freepgs))
> >   		echo 3 > /proc/sys/vm/drop_caches
> > -		if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
> > +		if ! echo $((lackpgs + nr_hugepgs_origin)) > /proc/sys/vm/nr_hugepages; then
> >   			echo "Please run this test as root"
> >   			exit $ksft_skip
> >   		fi
> > @@ -189,6 +189,7 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
> >   		done < /proc/meminfo
> >   		tries=$((tries - 1))
> >   	done
> > +	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
> >   	if [ "$freepgs" -lt "$needpgs" ]; then
> >   		printf "Not enough huge pages available (%d < %d)\n" \
> >   		       "$freepgs" "$needpgs"
> > @@ -532,6 +533,10 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh aligned
> >   CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
> > +if [ "${HAVE_HUGEPAGES}" = 1 ]; then
> > +	echo "$nr_hugepgs_origin" > /proc/sys/vm/nr_hugepages
> > +fi
> 
> FWIW, I think the tests should maybe be doing that (save+configure+restore)
> themselves, like we do with THP settings through.
> 
> thp_save_settings()
> thp_write_settings()
> 
> and friends.

For this va_high_addr_switch test, looks like we can do the save_setting,
write_setting and restore_setting in the va_high_addr_switch.sh.

> 
> This is not really something run_vmtests.sh should bother with.
> 
> A bigger rework, though ...

Totally agree, with the c interface to do that is better. then the
vm_runtest.sh would  be clean. It's a bigger rework outside of this topic.

> 
> -- 
> Cheers
> 
> David / dhildenb
> 


