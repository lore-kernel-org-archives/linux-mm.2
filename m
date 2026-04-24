Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E24FFED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C3F6B00A2; Fri, 24 Apr 2026 15:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D3A6B00AF; Fri, 24 Apr 2026 15:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C066B00B0; Fri, 24 Apr 2026 15:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1E06B00A2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:23:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27C551602FE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:23:02 +0000 (UTC)
X-FDA: 84694422204.22.3BEACE5
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2E6DA140010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:22:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BGSm0Ayh;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csVqsTPVwZnRAGi9vx1W5ZwqxSQGzc7MPqLazrUL+FI=;
	b=3ZVU89j2aM9tnL9YyailG2Bn46ArcnllyZEPzcfhIn7R/tDBg32++C2Wqc7v1FFP64i9Dj
	yoKvhQL1EFXzMk1zpL0jLQyBDrqTYq0Q2Q+ON4YnhJJKnsYgGRpuQoDZXI18T7uAm1vEKM
	IIRIx/tvMQbC71duIRZV03372xekIwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058580; a=rsa-sha256;
	cv=none;
	b=W4j6mWcYN4sP6LFpM7joaaLl4W48wsAamKGtVRlVWYuYXRtcs+rjkTTiocQsb6Jt2Jtj8W
	kXXRJD/QzABpBMHjonnyqohbnrf4e/w8zplJgREYNktBOrdR22Iu+7B3MN/ByWQcM4Sgsm
	LKqMdJyGSUaEkYXcFbPvNbRoJ6K6RO0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BGSm0Ayh;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=csVqsTPVwZnRAGi9vx1W5ZwqxSQGzc7MPqLazrUL+FI=; b=BGSm0AyhlQXPD4cBWWz292PN/6
	NggpRStwrlBlFg0LZS3Hb9lSTB2tkhWccIjz51pDfcCdL3/41CvKVo1mcSCDn24309i6zbCGyyYZ2
	jA0bgaB890tME+A71+BzzerccnbEM+GfyHhJNzSj/mGk6jsd4tjL9IbY0pRnj3DTJfQAKPKs7YMzz
	lTE7/U9f8BvYawwQXvN6iuVc85RHcMmt1ys0/KhpX06WdHmMgIrBxmlYIYQxSQytO8NV9Xn469fWV
	XmyFbFX/8HdNPNMfztrN4cpr/nPVgFYhnR3ynYRKWmfgAPksjrOmV+w+EmQFCtvT7o/vw545vb6bm
	g6o1QF7g==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGM71-0000000FOP4-1yUY;
	Fri, 24 Apr 2026 19:22:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F401F301142; Fri, 24 Apr 2026 21:22:50 +0200 (CEST)
Date: Fri, 24 Apr 2026 21:22:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Yosry Ahmed <yosry@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
	jannh@google.com, jgross@suse.com, seanjc@google.com,
	pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com,
	roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-ID: <20260424192250.GC3783056@noisy.programming.kicks-ass.net>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <20260424190141.GA3783056@noisy.programming.kicks-ass.net>
 <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E6DA140010
X-Rspam-User: 
X-Stat-Signature: xn7r71748tsgzt8twyso9sy58p8ufws1
X-HE-Tag: 1777058579-278439
X-HE-Meta: U2FsdGVkX1+4mErEXcu7ZYr3qk3Kqvt3gYw3ms4EKIiCw1Qkn8I7d4PbTECA5oKq5r9oT1aNexPkTpmRWIXuqeq4nOixaIU7pR9xtF4UDzkM3PSGD4dGMmWfWbfNfyzLdPS7cmppSVj4NTGdAd2lpKUobCswkxjQE5DP2IW8zaFz1BkqwkdF9LyS4COdHn5f/v3lmHyM6cgPxVDrwbadLjL5498vIxFr8V5nYaNlE88qIMDR1TraIi3DtoL9rOqN+HO4pXTK631omAWgICOldgP5zcxb8KZRxUHfoq+Mu+veqSwRQWMMFygRh7KksG2pEeEw5bDBSX+UgMNOWNG2Og6mW8EzHjQ8c1TmmNgWqJcVTRDCJHowkaNuYe3J7h1ucMUVitEyW1tz+2gTchvjIQX1TxopdT4gwqyXptdr/Ou1jsOpyMw96Cu71h9gp82gBz31DEmfkV3naSK0AU0iKMMSAlLy+960rAsOc3yuckhHY0k9esh8o/LycpO7VJpFKlIvEgLX/8D8H/fAdVjPCxoMJpYIbnDx0tbdeKJTG7Y7+/GsYPyQ+FaWaVlLrMtoX6ry9zF9dvc+oKKhNwOTE9X6HipRsgrdRfI8Bn/vywQ/Z6xuFzKoqXB0k/Pu91Mtc0/5fYA/mYcAYENkXac28cAFow2TavkUQvXPCpob5tpNRWcX1wp9hFlmYANWwBGNAi0bNdt/J2ZmGHG5uUANdbCKMj5OEXmLxFmHgqyyQcaKVOvJozhUU5iH+bwucXSNTuZUYINIq5yhOAGelJYprc3unPTiwvnYHhnQJTN/B3oEqHUCaHFLVrYrbnugEcZmVu0vLTFeJ1CJljz1PdEkzRtRvpJLnE1yCnx6zA/9jj/oBbe7U79b/9UuZAyUQseDYaVhFj4TMZ1CIOxywHpb5tj7L7Nwnonh66fzwngmEnU0ClUTKBYaO7ZBrXiT/9kn95Stnc8McZT66/Ms8x6
 T9Txgsnv
 MCyPWDh8qP4XPccqbMadCReVAU93Tjjb9BpGmtepzuXtucw1RwKYevH75T+Dw/xlqijaWSxOa7iD9TWsVrx5gW4pdx7RmXoWKbXDbzIgobu6d1IwUTtMHSm6XKiZEOoR9NCErHJMB1eE6VVPMR6qdfaXOA9rCagwdkKbXqRbvf7ZQzOQkRq9x2nJuLE+ww2YJeI59JpSYsRnff3vGq889dzyuBsgebhZC7PJboxY7eobHSShprAAVkMccB+A/Loxa7yxDFe7m/UESS7xiu7HXNUePSHpIn6/zacTnyXsCCGuX63BACmvmA/ghaYnWaKGSrtw6U17TDgaW6IDh5fjITQOW47AeLFYo/OSs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 03:12:34PM -0400, Zi Yan wrote:
> On 24 Apr 2026, at 15:01, Peter Zijlstra wrote:
> 
> > On Fri, Apr 24, 2026 at 11:50:03AM -0700, Yosry Ahmed wrote:
> >
> >> But I imagine it's useful for reviewers to see Sashiko's feedback as
> >> well (without having to go look on the website).
> >
> > That's why I have a script; if I press 'S' in mutt on an 0/n email, said
> > script goes and does webrequest to sashiko and inserts the review
> > comments into my local maildir as properly threaded replies to the
> > series at hand.
> >
> > No looking at website needed.
> 
> Do you mind sharing that script? It looks like a great work flow. Thanks.

Sure, it is in a 'works-for-me' state and probably should get a once
over before you run it locally to make sure it fits your environment (at
the very least you should probably change my email address :-)

This is cobbled toghether from a script I got from Thomas and staring at
the JSON with generous hints from Gemini (because I can't write Python
at all).

.muttrc has:

macro index S "<pipe-entry>grep -i \"\^Message-ID:\" | cut -d: -f2- | tr -d \" <>\" | ~/bin/sashiko.py<enter>"

sashiko.py:

---
#!/usr/bin/env python3

import sys
import mailbox
import requests
from argparse import ArgumentParser
from email.message import EmailMessage
from email.utils import formatdate
from datetime import datetime

def getsash(url, msgid):
    surl = f'{url.rstrip("/")}/api/patch'
    try:
        session = requests.Session()
        session.headers.update({'User-Agent': 'sash2txt_0.2'})
        resp = session.get(surl, params={'id': msgid}, timeout=30)

        if resp.status_code == 404:
            print(f"Error: Patch ID {msgid} not found (404).", file=sys.stderr)
            return

        resp.raise_for_status()
        data = resp.json()
    except requests.RequestException as ex:
        print(f"Request failed: {ex}", file=sys.stderr)
        return

    patches = data.get('patches', [])
    if not patches:
        print(f"No patches found for (msgid).", file=sys.stderr)
        return

    msgids = {}
    subjects = {}

    for p in patches:
        msgids[p['id']] = p['message_id']
        subjects[p['id']] = p['subject']

    reviews = data.get('reviews', [])
    if not reviews:
        print(f"No reviews found for {msgid}.", file=sys.stderr)
        return

    mdir = mailbox.Maildir('~/Maildir/');

    for i, r in enumerate(reviews):
        inline = r.get('inline_review', '') or ''
        if not inline:
            continue

        author_name = r.get('author_name', 'Sashiko Reviewer')
        author_email = r.get('author_email', 'noreply@sashiko.dev')

        msgid = msgids[r['patch_id']]
        subject = subjects[r['patch_id']]

        # Create the Email object
        msg = EmailMessage()
        msg['Subject'] = f"Re: {subject}"
        msg['From'] = f"{author_name} <{author_email}>"
        msg['To'] = "peterz@infradead.org"
        msg['Date'] = formatdate(localtime=True)

        # The critical threading headers
        msg['Message-ID'] = f"<review-{i}-{msgid}>"
        msg['References'] = f"<{msgid}>"
        msg['In-Reply-To'] = f"<{msgid}>"

        msg.set_content(inline)

        mdir.add(msg)

    mdir.flush()

if __name__ == '__main__':
    url = 'https://sashiko.dev/'

    # Check if there's data in stdin (piped input)
    if not sys.stdin.isatty():
        for line in sys.stdin:
            msgid = line.strip()
            if msgid:
                getsash(url, msgid)
    else:
        # Fallback to arguments if no pipe is detected
        parser = ArgumentParser(description='Sashiko retriever to mbox')
        parser.add_argument('msgid', nargs='?', help='Message id of the patch series')
        args = parser.parse_args()

        if args.msgid:
            getsash(url, args.msgid)
        else:
            print("Usage: echo <msgid> | ./sashiko.py OR ./sashiko.py <msgid>", file=sys.stderr)

