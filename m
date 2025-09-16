Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98ABFCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F373C8E0005; Tue, 16 Sep 2025 15:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7DA8E0001; Tue, 16 Sep 2025 15:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD398E0005; Tue, 16 Sep 2025 15:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1BE98E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:47:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A667C1DDEDD
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:47:43 +0000 (UTC)
X-FDA: 83896148406.06.F868D86
Received: from smtp78.iad3a.emailsrvr.com (smtp78.iad3a.emailsrvr.com [173.203.187.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id B1CD240007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:47:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=deepplum.com;
	spf=pass (imf12.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.78 as permitted sender) smtp.mailfrom=dpreed@deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758052061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BXpJcrdNgVxtvdMbqiu3WYLYsFbIJJYvBL1ItJ6+8eo=;
	b=HKcxECKTATFOIwrlwt2f94nPzfP4Qkbh1hgv3py230okxhgZpKlfl8UAaRqVClCM4j+jLy
	uT/pxPrmIaHkXpwsmJ/+xDGzWKuDYZWhvmOodWOwh8ftMNq7tp1SNRRrPoQ9xDp+ppTF9x
	uN9nBg8u4YOS4nzRQxeaND8BeegRfWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758052061; a=rsa-sha256;
	cv=none;
	b=IqKmzb6zOl8PaG6gKsQ93MeOIZcBmZ8VmnuzlNsEiIQt7a4PjYkcQhzyTfiGX0fMFl0/Iq
	gwJkkGm/SS2oMoDYTaKMMDCdSS+JBpBMXj/hOUddXKqJCPfxe4fIEEZr1xuxKPfccH67jw
	mnVLG1k+TXvQluGqKjKwVAVpjAsH7m0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=deepplum.com;
	spf=pass (imf12.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.78 as permitted sender) smtp.mailfrom=dpreed@deepplum.com
Received: from app50.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp26.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id C902A579E;
	Tue, 16 Sep 2025 15:47:40 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app50.wa-webapps.iad3a (Postfix) with ESMTP id A698E600C0;
	Tue, 16 Sep 2025 15:47:40 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Tue, 16 Sep 2025 15:47:40 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Tue, 16 Sep 2025 15:47:40 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "James Houghton" <jthoughton@google.com>
Cc: "Axel Rasmussen" <axelrasmussen@google.com>,
 "Peter Xu" <peterx@redhat.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <CADrL8HWS7h0e0AcjbE0npoVwqvWK6c_aqML4T+MJnTkCz5AcNg@mail.gmail.com>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com> 
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com> 
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com> 
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com> 
 <CADrL8HWS7h0e0AcjbE0npoVwqvWK6c_aqML4T+MJnTkCz5AcNg@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1758052060.67927840@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: 09f52ec7-76ad-48f0-a45c-f6dc4f05a901-1-1
X-Stat-Signature: peirox3i4b9rdeox66dfc1o8rrhood7c
X-Rspam-User: 
X-Rspamd-Queue-Id: B1CD240007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758052061-835014
X-HE-Meta: U2FsdGVkX1863Vd2NjP3g/nxIzhEAy3N5Lc7dctK6Feu6OJxPpczswBZALUh9IeX25BDiODq3ehj7Vyw0hc80BvSiQsv9sW7R/C1wO64e9XkdOjt3ogeSGH1Nuvy+kTRIDp6cds6i7wxsMiHKVKrCv+xA+Ss+SFyl7Wvd2eKyUMBHfGdKOzzCiSqQbN34tOUeARcjwsnZcl7X9e/YJTfjq4s7BJddre8jIbwn+Y544MKgZ6WGwd8fSKMxOqr73Bteb8SE0F/n/ed8Iav6mg2MG+Z5ds1QHdKj90UAawykitXuxep8RSVSk6tAqV2MQ+jKcAWtUEWHZ7KkOnWZZZWUd3tyBmOGS5qwOA6Q7nJ1ElLIP8qf0LAHwUqb50+TD72mB2eHleNfFzaaaE8qgECx+3rBASKkTkxHQ9SFvh60086mQqmi6Wgdjct85KVpHv+JVxBBptQho0Z7zleLrlV8+61MgwE0f7vUG3aaLOgs8sAXUXpzo5GraY12QYetuDbMgneNW9hg8SedQ+9yXPompqwKFIvWYlAetzYYoeCptdvhTvzmsrVNsmRaz5H/kvpZ0PgkXrBegqZeL6NDgdMtZFN1Ptb3FW66rQ+xqa9BRp/jQaVM7GBsgQ3Ppn8YaSBkIXuSgpAeX1tTqF+jPP9SXNEfELUKSFyxBJ8+WU83UkEbux4NscpC4GA/BqAU+jksb7tBg2wHTPhJS7ikK2RcmBN4ENdjtEGiS0X/Q37kKEAgd/42IGBNuGI6/MtLwS8qZAIcBAo7RPcEP7mGFw4KYJ1ihZ+Fn3Bof2G8Nlk3b4PmzugoQnIrUaGEDrA3wgT9ZWcl2XaNd0AgciS6QWtMcYQ3/Tsxug2o90KqLO8hEMTBt6brLdTfxrsjFFu+gKVGoMU8Qr0/7rOcRK6ZyFBXC7fyI60+mnuARqMSqFf33fBK+KwKUjy/5e3PbEtfURurRVRx4Uzs0KLhs8x4N7
 REJqg4bg
 T+aXWlW30LdffBcNiK9t7RWRNd2KbudnMuFwZjcpx2Sd2cOge5ZUBYXAXahLlIO8kwu7Zuv7ZLv2GojFaTpxtoLhrs/TH76gWmFe/XOg1/bqRxBNC2ynBRBuJXwlUzBNECLn0FndlxNB1zNXerFSQrk49B2J+wz1cNhIRSoCFlzH90DEdhVUfj6oV3xf0AuP3RZq2uiR6B4ovGWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001625, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=0AOn Tuesday, September 16, 2025 15:10, "James Houghton" <jthoughton@go=
ogle.com> said:=0A=0A> On Tue, Sep 16, 2025 at 11:35=E2=80=AFAM Axel Rasmus=
sen=0A> <axelrasmussen@google.com> wrote:=0A>>=0A>>=0A>>=0A>> On Tue, Sep 1=
6, 2025 at 10:27=E2=80=AFAM David P. Reed <dpreed@deepplum.com>=0A>> wrote:=
=0A>>>=0A>>> Than -=0A>>>=0A>>> Just to clarify -=0A>>> Looking at the man =
page for UFFDIO_API, there are two "feature bits" that=0A>>> indicate cases=
 where "minor" handling is now supported, and can be enabled.=0A>>> UFFD_FE=
ATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM=0A>>> In my reading of t=
he documents, these seem to imply that before they were added=0A>>> as new =
features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were supported, and=0A>>>=
 that the "new" additions to the MINOR mode were just for HUGETLBFS and=0A>=
>> MAP_SHARED cases.=0A>>=0A>>=0A>> Actually minor fault support didn't exi=
st at all before those two features were=0A>> added. :)=0A>>=0A>> You are r=
ight that userfaultfd's use of "minor fault" is (unfortunately) slightly=0A=
>> different from the meaning in other contexts. I think the more normal me=
aning is,=0A>> faults which do not incur I/O (i.e., swap faults and file fa=
ults [i.e., faults on=0A>> non-swap-backed pages] are major, other faults a=
re minor).=0A>>=0A>> For userfaultfd, a minor fault is a fault where the pa=
ge already exists in the=0A>> page cache, but the page table entry wasn't s=
etup. I don't think that scenario=0A>> can ever happen for anonymous, priva=
te mappings, so it doesn't really make sense=0A>> to be able to register su=
ch mappings in this mode. If you create a mapping with=0A>> mmap(MAP_ANON|M=
AP_PRIVATE) and then access it (read or write), that fault=0A>> requires al=
location of a new page, so userfaultfd does not consider that a "minor=0A>>=
 fault". My recollection though is if you make a file on tmpfs or hugetlbfs=
,=0A>> fallocate() it or whatever, and you MAP_PRIVATE that file, *that* re=
gistration=0A>> will work.=0A> =0A> Ah! You're right... MAP_PRIVATE *is* su=
pported (for tmpfs and=0A> hugetlbfs only), and UFFDIO_CONTINUE will, upon =
finding the page in=0A> the page cache, install a RO PTE for it.=0A> =0A> B=
ut what happens when the write comes after installing the RO PTE? My=0A> re=
ading of the code today makes me think that we'd get a minor=0A> userfault =
and then be unable to continue...! (The only reasonable=0A> behavior is tha=
t CoW is done without triggering a userfault... I=0A> assumed/thought this =
was the behavior today. I wish I had time to test=0A> this -- I hope I'm mi=
sreading it.)=0A> =0A> :( Here I was thinking I understood how userfaultfd =
minor faults worked.=0A> =0A=0ASo did I. It's kind of confusing. I suppose =
`git blame` might suggest when the code that doesn't like MAP_PRIVATE|MAP_A=
NONYMOUS pages in the UFFDIO_REGISTER minor call was introduced... I know t=
hat MAP_SHARED|MAP_ANONYMOUS pages allows minor faults to be registered on =
them - and the only difference really is the passing of the mapping to fork=
ed clones (and the COW behavior resulting from sharing until written, but m=
inor mapping has nothing to do with write faults particularly - reading can=
 cause minor faults too).=0A=0A


