Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E40E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918816B0088; Wed, 18 Feb 2026 07:54:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C68C6B0089; Wed, 18 Feb 2026 07:54:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB486B008A; Wed, 18 Feb 2026 07:54:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 690496B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:54:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E2B41B3D24
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:54:47 +0000 (UTC)
X-FDA: 84457571814.19.EECB51B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id C224BA000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:54:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EWdE9Pc+;
	spf=pass (imf25.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlA1AbMzOeTmhaj5e99ZkJ4aaV0Ydzpz7qXESwhzBw0=;
	b=s+JMh7j04TX5wLGTfaGBMv6wh+tn/jhJ183idC55Nws1K1VZhSLpM+MiiZhV+AEWAG4tUJ
	pLKiRCstNA6H/NvB5LLiDQgVUHF2FKw0q9N7Ol7sxNiBcW3Ye5XwVLa9TkNzfAGG46JoL8
	WC0lGzy3ieNrmNUcIwEqoQmoK8GHljQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419284; a=rsa-sha256;
	cv=none;
	b=cuSIMKW4Qy1BMzeKZCQ2pOM/zkIiWVOkN8G7on0BstZU3A7w7NP40fqNEw7YqJRD7c4bXP
	/omhVMZIxan9oWDwqtF9dOqQxgQBNUiVlqFdb3IIBxxGeB8Z8EcdI2l3zBTB2uTM0iRZL2
	T85t2p2sL7e8d33smh7YIRXB9z90p1I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EWdE9Pc+;
	spf=pass (imf25.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61I9KWwC3661553;
	Wed, 18 Feb 2026 12:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=BlA1AbMzOeTmhaj5e99ZkJ4aaV0Ydz
	pz7qXESwhzBw0=; b=EWdE9Pc+rdxxTC8NAoOgznIV/LjA1IVskBFKXQuVm26iIA
	IHPQ/mZhu82rmbL+PHKciaRpKm2FC20POFYFYT/pCwJ4V7U+qmTBOzPn5LwKwyAK
	nLdlgu264oeKZ7dbqjjG7snnTXAM4Wnz7L8guKvTQvP2elc34nPaRb72ffZtk1/e
	VusELSQfV23whrJXiGBjhzaxjzy7+zKb0h5QPe3ivi4DIfDQGAQVp1jky5TrccsT
	eu4wuYPkzjxcq6Hkdr1aPRIi/XfWoyTxA+1/pruuQarggSnOMgy/w4SnNnNqhxnc
	SCI861u8a1CwDBde0udKshfqUaiWEX847yo5oweQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjg4tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 12:54:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61I8e4Zu001419;
	Wed, 18 Feb 2026 12:54:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb2bftac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 12:54:34 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61ICsWv553674438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 12:54:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E7CA20040;
	Wed, 18 Feb 2026 12:54:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD1A720043;
	Wed, 18 Feb 2026 12:54:27 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.27.220])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Feb 2026 12:54:27 +0000 (GMT)
Date: Wed, 18 Feb 2026 18:24:25 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Pankaj Raghav <pankaj.raghav@linux.dev>,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        Andres Freund <andres@anarazel.de>, djwong@kernel.org,
        john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
        ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
        dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
        gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
        vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZW2geKlQESzxXzV@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
 <aZS18m1eIxjDmyBa@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <aZUHHvNl6cQr-uwd@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZUHHvNl6cQr-uwd@dread>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -fnHeqLWXVntKC1VPi5-hEcRrUMZ1eZU
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=6995b68b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=mABpun1c11mrw8mCog8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDExMCBTYWx0ZWRfXzmhqwlV11zuf
 HnmAQnAhefdBCrARMdXeJQSd44KB601SjyK/JR0C6gSI9FuU434jMjIZRB9peArV6ksn6dB2Tsi
 +CKCwHjSLZHhmIeidEXc/OuKSEdQiwBeO3dceRy2JWC1wkS4RfklibBsSwHV0g4sP0Go5+lUnrI
 J8w9YDYeei1TO3C51EgMJUXHPoieEjezgBQW7Px/RyxlZlURBGKTsRI709hFtHi9uXlgScWuCOI
 2/+K1Da1QZIKtGU3FvITkQnLC1t7+zZH1tKAWTueD49VcleXglUDjhdvTdqLsxUchkMMoZfwHSY
 GTubwyHEfgWFZFR8jvUMmNph8Hqkv1r7evKqLlI+yTQoFimn0cTTwquPKo0dNZMvUUiRwMz8yR7
 XKHguLAmceAQC1oPsMPCjwDrrjCEi2SSYMojmBcD7OMyTXGmo403Qrfp8IUIC9WfdGFDEIA72Dp
 e9tPMACa/OGWvsZOx6Q==
X-Proofpoint-GUID: VKj-YQ9wKR8GjOpfDRXrT459fMxy1rGC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-18_02,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602180110
X-Rspamd-Server: rspam09
X-Stat-Signature: ry14io17596qj7d9ofzoeq1nmp1mqb9r
X-Rspamd-Queue-Id: C224BA000D
X-Rspam-User: 
X-HE-Tag: 1771419284-499007
X-HE-Meta: U2FsdGVkX1+DKO7EZWU8wtTsCnDcoHsFPyxFkxliXoBFyO7jxOtSy0+p8095MPpJZM6DgdSbAqt+46nvyXmhj9rsxHQgc9wjc1EQj7aKp6ED6QYeIIXLWZ6voWOSw2FtLbkXKmiM5H/g3Rhd2XD0LdeoP3FnBFeTb+6IDnOQgrNeoXu/lgXfC7rTrXmjPIL4A1RSrJ1PjRi0FYOjc483SauhQjmZZg81O9u8ZGCv6MP7D8oSlIFyCyDvBdtgfgIlIKypnmwr8IUH/aBClYVW9bFeT3WeE009xxeAWkBTIGN7cV9QFTf0INmJP9UWJNxC/oAdbfvtsy5q5Zec8bDquHOvt3lzQdshaWGUqowF38hYxmIJpA4+8EvpjB6MgXn5V1nE6XphlXmZp9IPuLdJLj1vIdh4K9h6aZdIKB0O5bvYHYcY1+5NGMdSd2Z/nCazSqpDA51OBppl6hPUTyHDAll2D99lh3BwYYQ4gN8H0XwZ5KseKoCuLcdc3tsCzY6NfN1AozZ5lihjTH1U4K/FKVD2it+sAKc500u6k1NBDSblDGysu4vfE0xQOjoEneliU6rViaW+PrJDrdO13vuz4aOzz5z90pznGVxo3QwB3nHPenrul5K32+C4Fnr7LhdoJOiEVIaYXOUEAGEvvVele0DCqlwu6MXaeLMVAi9aI06WkFt2iSXO/JWTmM+d6AdcD/vHSvXN5KqSFrEmdste6Y71STgdYU1E+lUIVh983S0WdIt2LrtMOrfVlOvUmVV44z2n+pTOYja8F7FBy5I0+LL5YEkHfownOQBIlcI5ddLvfASWmlBvHrx1O4+LTIdgG7ixvhlXJSwSE5MwrcbN/2yoEf5D+IkVPvoFl9fC2BChAzvqfmHSIIciWZQkBwO9Re6D6hTsXQ5sQWCehcB1MlmkI9w4omD59w7ByvA/IBODkzXkYSHr8sHSqFxP0R2gIhx659PbJkb+MnvzNP3
 Hna8yAzo
 s4XTb4Ol63OjVBDnIpBVljPjIgWUOCPfxK6aE+rAtGVexGMGCtSsfqLrRf7WDPtj39j5/Pywh1ybZhTXFnxYktb35VfNM/4yb9338VxDdDs/DArb/AgGwAg5t38ToYpMpYwyzxtLEKb54/YgNw0o9yn33lwegCNd55VB5TUTyYxelBInthkPYECabuF075O9364AhmGT3pdd0oqV1gAb4UpIsUlXQZTkdwGYnCmvHdX+b6C6jfkD2Ei59toWWnHui88jhu4QLCE1KqV6H1muv1X3XYwPLAq7GPkU09O2aDS5LOIg4wvKOhp8hCjSNO9+IIAPT2BdxpRVB6e5yPY0/GxyKNOBCTeRHH3PBrIsjMkrSugDQS4lBXUOZV2Hh5Z2EZOaZ3jWi4NZf5X0Xxx29sq3/WvDHq4giPjFbe8JRhbkCv7nDpym8DNXjVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 11:26:06AM +1100, Dave Chinner wrote:
> On Wed, Feb 18, 2026 at 12:09:46AM +0530, Ojaswin Mujoo wrote:
> > On Mon, Feb 16, 2026 at 12:38:59PM +0100, Jan Kara wrote:
> > > Hi!
> > > 
> > > On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
> > > > Another thing that came up is to consider using write through semantics 
> > > > for buffered atomic writes, where we are able to transition page to
> > > > writeback state immediately after the write and avoid any other users to
> > > > modify the data till writeback completes. This might affect performance
> > > > since we won't be able to batch similar atomic IOs but maybe
> > > > applications like postgres would not mind this too much. If we go with
> > > > this approach, we will be able to avoid worrying too much about other
> > > > users changing atomic data underneath us. 
> > > > 
> > > > An argument against this however is that it is user's responsibility to
> > > > not do non atomic IO over an atomic range and this shall be considered a
> > > > userspace usage error. This is similar to how there are ways users can
> > > > tear a dio if they perform overlapping writes. [1]. 
> > > 
> > > Yes, I was wondering whether the write-through semantics would make sense
> > > as well. Intuitively it should make things simpler because you could
> > > practially reuse the atomic DIO write path. Only that you'd first copy
> > > data into the page cache and issue dio write from those folios. No need for
> > > special tracking of which folios actually belong together in atomic write,
> > > no need for cluttering standard folio writeback path, in case atomic write
> > > cannot happen (e.g. because you cannot allocate appropriately aligned
> > > blocks) you get the error back rightaway, ...
> > 
> > This is an interesting idea Jan and also saves a lot of tracking of
> > atomic extents etc.
> 
> ISTR mentioning that we should be doing exactly this (grab page
> cache pages, fill them and submit them through the DIO path) for
> O_DSYNC buffered writethrough IO a long time again. The context was
> optimising buffered O_DSYNC to use the FUA optimisations in the
> iomap DIO write path.
> 
> I suggested it again when discussing how RWF_DONTCACHE should be
> implemented, because the async DIO write completion path invalidates
> the page cache over the IO range. i.e. it would avoid the need to
> use folio flags to track pages that needed invalidation at IO
> completion...
> 
> I have a vague recollection of mentioning this early in the buffered
> RWF_ATOMIC discussions, too, though that may have just been the
> voices in my head.

Hi Dave,

Yes we did discuss this [1] :)

We also discussed the alternative of using the COW fork path for atomic
writes [2]. Since at that point I was not completely sure if the
writethrough would become too restrictive of an approach, I was working
on a COW fork implementation.

However, from the discussion here as well as Andres' comments, it seems
like write through might not be too bad for postgres.

> 
> Regardless, we are here again with proposals for RWF_ATOMIC and
> RWF_WRITETHROUGH and a suggestion that maybe we should vector
> buffered writethrough via the DIO path.....
> 
> Perhaps it's time to do this?

I agree that it makes more sense to do writethrough if we want to have
the strict old-or-new semantics (as opposed to just untorn IO
semantics). I'll work on a POC for this approach of doing atomic writes,
I'll mostly try to base it off your suggestions in [1].

FWIW, I do have a somewhat working (although untested and possible
broken in some places) POC for performing atomic writes via XFS COW fork
based on suggestions from Dave [2]. Even though we want to explore the
writethrough approach, I'd just share it here incase anyone is
interested in how the design is looking like:

https://github.com/OjaswinM/linux/commits/iomap-buffered-atomic-rfc2.3/

(If anyone prefers for me to send this as a patchset on mailing list, let
me know)

Regards,
ojaswin

[1] https://lore.kernel.org/linux-fsdevel/aRmHRk7FGD4nCT0s@dread.disaster.area/
[2] https://lore.kernel.org/linux-fsdevel/aRuKz4F3xATf8IUp@dread.disaster.area/

> 
> FWIW, the other thing that write-through via the DIO path enables is
> true async O_DSYNC buffered IO. Right now O_DSYNC buffered writes
> block waiting on IO completion through generic_sync_write() ->
> vfs_fsync_range(), even when issued through AIO paths.  Vectoring it
> through the DIO path avoids the blocking fsync path in IO submission
> as it runs in the async DIO completion path if it is needed....
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

